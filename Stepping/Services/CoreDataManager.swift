//
//  CoreDataManager.swift
//  Stepping
//
//  Created by Neso on 2020/10/01.
//

import Foundation
import CoreData

class CoreDataManager {

	private (set) var context = PersistenceController.shared.container.viewContext;

	func getBeacons() -> [BeaconItem] {
		let request = NSFetchRequest<BeaconItem>(entityName: "BeaconItem")
		return try! self.context.fetch(request)
	}

	func getItemById(_ uuid: UUID) -> BeaconItem? {
		let request = NSFetchRequest<BeaconItem>(entityName: "BeaconItem")
//		request.predicate = NSPredicate(format: "uuid == %@", id.uuidString)


		let result = try! context.fetch(request)
		return result.first(where: {$0.uuid == uuid})
	}

	func updateBeaconLastPromixity(_ beaconItem: BeaconItem) {
		guard let item = getItemById(beaconItem.uuid!) else {
			return
		}

		item.setValue(beaconItem.lastProximity, forKey: "lastProximity")

		do {
			try context.save()
		} catch {
			print(error.localizedDescription)
		}
	}
}
