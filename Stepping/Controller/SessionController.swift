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
	let notificationService = NotificationService()
	
	private var beaconExitEventCanceller: AnyCancellable? = nil
	private var beaconEnterEventCanceller: AnyCancellable? = nil

	init() {
		self.beaconExitEventCanceller = self.beaconDetector.exists.sink { beaconItem in
			self.notificationService.show(pushNotificationId: beaconItem.uuid!.uuidString, title: beaconItem.exitTitle!, message: beaconItem.exitMessage!)
		}
		self.beaconEnterEventCanceller = self.beaconDetector.enters.sink { beaconItem in
			self.notificationService.show(pushNotificationId: beaconItem.uuid!.uuidString, title: beaconItem.enterTitle!, message: beaconItem.enterMessage!)
		}
	}
	
	func updateMonitoring() {
		beaconDetector.startMonitoring()
	}
	
	func stopMonitoring(beaconItem: BeaconItem) {
		beaconDetector.stopScanning(beaconItem: beaconItem)
	}
}
