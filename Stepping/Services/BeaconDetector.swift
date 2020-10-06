//
//  BeaconDetector.swift
//  Stepping
//
//  Created by Neso on 2020/10/01.
//

import Foundation
import CoreLocation
import Combine
import CoreData

class BeaconDetector: NSObject, ObservableObject, CLLocationManagerDelegate {

	private let locationManager = CLLocationManager()

	@Published private (set) var permissionGranted = false
	private (set) var exists = PassthroughSubject<BeaconItem, Never>()
	private (set) var enters = PassthroughSubject<BeaconItem, Never>()

	@Published var beaconItems: [UUID: BeaconItem] = [:]
	@Published var foundBeacons: [UUID: CLBeacon] = [:]



	override init() {
		super.init()
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways {
			publish(permissionGranted: true)

			if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
				startMonitoring()
				return
			}
		}
		publish(permissionGranted: false)
	}

	func publish(permissionGranted: Bool) {
		DispatchQueue.main.async {
			self.permissionGranted = permissionGranted
		}
	}

	func startMonitoring() {
		stopScanningAll()
		for item in PersistenceController.shared.getBeacons() {
			guard let beaconID = item.uuid, beaconItems[beaconID] == nil else { return }

			let constraint = CLBeaconIdentityConstraint(uuid: item.uuid!,
														major: CLBeaconMajorValue(item.major),
														minor:  CLBeaconMinorValue(item.minor))
			locationManager.startRangingBeacons(satisfying: constraint)


			let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: item.name!)
			locationManager.startMonitoring(for: beaconRegion)

			beaconItems[item.uuid!] = item
		}
	}

	func stopScanning(beaconItem: BeaconItem) {
		let beaconRegion = CLBeaconRegion(uuid: beaconItem.uuid!, identifier: String(beaconItem.name!))
		locationManager.stopMonitoring(for: beaconRegion)

		let constraint = CLBeaconIdentityConstraint(uuid: beaconItem.uuid!,
													major: CLBeaconMajorValue(beaconItem.major),
													minor:  CLBeaconMinorValue(beaconItem.minor))

		locationManager.stopRangingBeacons(satisfying: constraint)
		beaconItems.removeValue(forKey: beaconItem.uuid!)
		foundBeacons.removeValue(forKey: beaconItem.uuid!)
	}

	func stopScanningAll() {
		for item in PersistenceController.shared.getBeacons() {
			let constraint = CLBeaconIdentityConstraint(uuid: item.uuid!,
														major: CLBeaconMajorValue(item.major),
														minor:  CLBeaconMinorValue(item.minor))
			locationManager.stopRangingBeacons(satisfying: constraint)

			let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: item.name!)
			locationManager.stopMonitoring(for:beaconRegion)
		}

		self.beaconItems = [:]
		self.foundBeacons = [:]
	}

	func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
		guard let beaconRegion = region as? CLBeaconRegion else {
			return
		}

		guard let beacon = beaconItems[beaconRegion.uuid] else {
			return
		}

		if beacon.notifyOnExit {
			exists.send(beaconItems[beaconRegion.uuid]!)
		}
	}

	func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
		guard let beaconRegion = region as? CLBeaconRegion else {
			return
		}

		guard let beacon = beaconItems[beaconRegion.uuid] else {
			return
		}

		if beacon.notifyOnEnter {
			enters.send(beaconItems[beaconRegion.uuid]!)
		}
	}

	func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
		#if DEBUG
		print("monitored region count:\(locationManager.monitoredRegions.count)")
		print("montired beacon count= \(beaconItems.count)")
		print("found beacon count= \(beacons.count)")
		print("beacon: \(String(describing: beacons.first?.uuid))")
		#endif

		for item in beacons {
			self.foundBeacons[item.uuid] = item
		}
	}
}
