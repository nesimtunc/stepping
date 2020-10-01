//
//  Persistence.swift
//  Stepping
//
//  Created by Neso on 2020/09/23.
//

import CoreData

fileprivate func createSomeDummyData(count:Int) -> PersistenceController {
	let result = PersistenceController(inMemory: true)
	if count == 0 {
		return result
	}
	let viewContext = result.container.viewContext
	for i in 1..<count {
		let newItem = BeaconItem(context: viewContext)
		newItem.id = UUID(uuidString: "77048D46-2AB4-44B2-9C72-2764B8A899C5")
		newItem.name = "Beacon \(i)"
		newItem.major = Int16(10 * i)
		newItem.minor = Int16(1 * i)
		newItem.title = "Did you forget from?"
		newItem.message = "Vallet something?"
		newItem.notifyOnExit = true
		newItem.notifyOnEnter = false
		newItem.timestamp = Date()
	}
	do {
		try viewContext.save()
	} catch {
		let nsError = error as NSError
		fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
	}
	return result
}

struct PersistenceController {
	static let shared = PersistenceController()
	
	static var preview: PersistenceController = {
		createSomeDummyData(count: 3)
	}()
	
	static var fullOfDataPreview: PersistenceController = {
		createSomeDummyData(count: 11)
	}()
	
	let container: NSPersistentCloudKitContainer
	
	init(inMemory: Bool = false) {
		container = NSPersistentCloudKitContainer(name: "Stepping")
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
	}
}
