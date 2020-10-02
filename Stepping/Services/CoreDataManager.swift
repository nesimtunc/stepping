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

	let entityName =  "BeaconItem"

	func getBeacons() -> [BeaconItem] {
		let request = NSFetchRequest<BeaconItem>(entityName: entityName)
		return try! self.context.fetch(request)
	}

	func getItemById(_ uuid: UUID) -> BeaconItem? {
		let request = NSFetchRequest<BeaconItem>(entityName: entityName)

		let result = try! context.fetch(request)
		// NSPredicate didn't work for UUID.
		return result.first(where: {$0.uuid == uuid})
	}
}
