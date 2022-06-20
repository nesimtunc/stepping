//
//  PersistenseTests.swift
//  SteppingTests
//
//  Created by Neso on 2020/09/30.
//

@testable import Stepping
import XCTest
import CoreData

class PersistenceTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    var validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
    
    override func setUp() {
        super.setUp()
        self.context = PersistenceService.shared.container.viewContext;
    }
    
    override func tearDown() {
        self.context = nil
        super.tearDown()
    }
    
    private func createDummyItem() {
        let newItem = BeaconItem(context: self.context)
        newItem.uuid = UUID(uuidString: validUUIDStr)
        newItem.name = "Test Beacon"
        newItem.major = 3
        newItem.minor = 1
        newItem.exitTitle = "Did you forget something from your room?"
        newItem.exitMessage = "Wallet, Pasmo"
        newItem.timestamp = Date()
        newItem.notifyOnEnter = false
        newItem.notifyOnExit = true
    }
    
    private func getItemById(id: String) -> NSManagedObject {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BeaconItem")
        request.predicate = NSPredicate(format: "uuid == %@", validUUIDStr)
        
        let result = try! self.context.fetch(request)
        return (result.first as? NSManagedObject)!
    }
    
    func test_create_new_beacon_item() throws {
        createDummyItem()
        XCTAssertNoThrow(try self.context.save())
    }
    
    func test_update_existing_item() throws {
        createDummyItem()
        
        let item = getItemById(id: validUUIDStr)
        
        item.setValue("Updated Beacon", forKey: "name")
        
        XCTAssertNoThrow(try self.context.save())
        
        let updatedItem = getItemById(id: validUUIDStr)
        
        
        XCTAssertEqual((item.value(forKey: "name") as! String), (updatedItem.value(forKey: "name") as! String))
    }
    
    func test_delete_existing_item() throws {
        createDummyItem()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BeaconItem")
        request.predicate = NSPredicate(format: "uuid == %@", validUUIDStr)
        
        let result = try! self.context.fetch(request)
        let item = result.first as? NSManagedObject
        
        self.context.delete(item!)
        
        XCTAssertNoThrow(try self.context.save())
    }
}
