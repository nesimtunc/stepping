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

	var dbContext: NSManagedObjectContext!

	private let locationManager = CLLocationManager()

	@Published private (set) var permissionGranted = false
	private (set) var exists = PassthroughSubject<BeaconItem, Never>()
	private (set) var enters = PassthroughSubject<BeaconItem, Never>()

	@Published private(set) var beaconItems: [UUID: BeaconItem] = [:]

	override init() {
		self.dbContext = PersistenceController.shared.container.viewContext
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
		for item in getBeacons() {
			guard let beaconID = item.id, beaconItems[beaconID] == nil else { return }

			let constraint = CLBeaconIdentityConstraint(uuid: item.id!,
														major: CLBeaconMajorValue(item.major),
														minor:  CLBeaconMinorValue(item.minor))
			locationManager.startRangingBeacons(satisfying: constraint)


			let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: item.name!)
			locationManager.startMonitoring(for: beaconRegion)

			beaconItems[item.id!] = item
		}
	}

	func stopScanning(beaconItem: BeaconItem) {
		let beaconRegion = CLBeaconRegion(uuid: beaconItem.id!, identifier: String(beaconItem.name!))
		locationManager.stopMonitoring(for: beaconRegion)

		let constraint = CLBeaconIdentityConstraint(uuid: beaconItem.id!,
													major: CLBeaconMajorValue(beaconItem.major),
													minor:  CLBeaconMinorValue(beaconItem.minor))

		locationManager.stopRangingBeacons(satisfying: constraint)
		beaconItems.removeValue(forKey: beaconItem.id!)
	}

	func stopScanningAll() {
		for item in getBeacons() {
			let constraint = CLBeaconIdentityConstraint(uuid: item.id!,
														major: CLBeaconMajorValue(item.major),
														minor:  CLBeaconMinorValue(item.minor))
			locationManager.stopRangingBeacons(satisfying: constraint)

			let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: item.name!)
			locationManager.stopMonitoring(for:beaconRegion)
		}

		self.beaconItems = [:]
	}

	func getBeacons() -> [BeaconItem] {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BeaconItem")
		return try! self.dbContext.fetch(request) as! [BeaconItem]
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
		#endif
	}
}
