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
	
    private var beaconExitEventCanceller = Set<AnyCancellable>()
	private var beaconEnterEventCanceller = Set<AnyCancellable>()

	init() {
		self.beaconDetector.exists.sink { beaconItem in
			self.notificationService.show(pushNotificationId: beaconItem.uuid!.uuidString,
                                          title: beaconItem.exitTitle!,
                                          message: beaconItem.exitMessage!)
        }
        .store(in: &beaconExitEventCanceller)
        
		self.beaconDetector.enters.sink { beaconItem in
			self.notificationService.show(pushNotificationId: beaconItem.uuid!.uuidString,
                                          title: beaconItem.enterTitle!,
                                          message: beaconItem.enterMessage!)
        }
        .store(in: &beaconEnterEventCanceller)
	}
	
	func updateMonitoring() {
        beaconDetector.stopScanningAll()
		beaconDetector.startMonitoring()
	}
	
	func stopMonitoring(beaconItem: BeaconItem) {
		beaconDetector.stopScanning(beaconItem: beaconItem)
	}
}
