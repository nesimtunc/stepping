//
//  SessionController.swift
//  Stepping
//
//  Created by Neso on 2020/10/01.
//

import Foundation
import Combine
import CoreData

class SessionController: ObservableObject {

	let beaconDetector = BeaconDetector()
	private let notificationService = NotificationService()
	
	private var beaconExitEventCanceller: AnyCancellable? = nil
	private var beaconEnterEventCanceller: AnyCancellable? = nil

	init() {
		self.beaconExitEventCanceller = self.beaconDetector.exists.sink { beaconItem in
			self.notificationService.show(pushNotificationId: beaconItem.uuid!.uuidString, title: beaconItem.title!, message: beaconItem.message!)
		}
		self.beaconEnterEventCanceller = self.beaconDetector.enters.sink { beaconItem in
			self.notificationService.show(pushNotificationId: beaconItem.uuid!.uuidString, title: beaconItem.title!, message: beaconItem.message!)
		}
	}
	
	func updateMonitoring() {
		beaconDetector.startMonitoring()
	}
	
	func stopMonitoring(beaconItem: BeaconItem) {
		beaconDetector.stopScanning(beaconItem: beaconItem)
	}
}
