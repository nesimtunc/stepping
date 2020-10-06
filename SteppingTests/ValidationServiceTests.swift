//
//  ValidationService.swift
//  SteppingTests
//
//  Created by Neso on 2020/09/29.
//

import XCTest
@testable import Stepping

class ValidationServiceTests: XCTestCase {
	
	var validationService: ValidationService!
	
	override func setUp() {
		super.setUp()
		self.validationService = ValidationService()
	}
	
	override func tearDown() {
		self.validationService = nil
		super.tearDown()
	}
	
	func test_empty_Beacon_UUID_should_throw_invalidUUID_error() throws {
		let expectedError = ValidationError.invalidUUID
		var error: ValidationError?
		
		XCTAssertThrowsError(try self.validationService.createSteppingBeacon(id: "invalid uuid",
																		   name: "Test Becaon",
																		   major: "3",
																		   minor: "1",
																		   title: nil,
																		   message: "Wallet, Pasmo",
																		   notifyOnExit: true,
																		   notifyOnEnter: false))
		{ throwError in
			error = throwError as? ValidationError
		}
		
		XCTAssertEqual(expectedError, error)
	}
	
	func test_empty_Beacon_name_should_throw_nameRequired_error() throws {
		let expectedError = ValidationError.nameRequired
		var error: ValidationError?
		
		let validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
		
		XCTAssertThrowsError(try self.validationService.createSteppingBeacon(id: validUUIDStr,
																		   name: " ",
																		   major: "3",
																		   minor: "1", title: nil,
																		   message: "Wallet, Pasmo",
																		   notifyOnExit: true,
																		   notifyOnEnter: false))
		{ throwError in
			error = throwError as? ValidationError
		}
		
		XCTAssertEqual(expectedError, error)
	}
	
	func test_invalid_Beacon_major_no_should_throw_invalidMajor_error() throws {
		let expectedError = ValidationError.invalidMajor
		var error: ValidationError?
		
		let validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
		
		XCTAssertThrowsError(try self.validationService.createSteppingBeacon(id: validUUIDStr,
																		   name: "Test Beacon",
																		   major: "",
																		   minor: "1",
																		   title: nil,
																		   message: "Wallet, Pasmo",
																		   notifyOnExit: true,
																		   notifyOnEnter: false))
		{ throwError in
			error = throwError as? ValidationError
		}
		
		XCTAssertEqual(expectedError, error)
	}
	
	
	func test_invalid_Beacon_minor_no_should_throw_invalidMinor_error() throws {
		let expectedError = ValidationError.invalidMinor
		var error: ValidationError?
		
		let validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
		
		XCTAssertThrowsError(try self.validationService.createSteppingBeacon(id: validUUIDStr,
																		   name: "Test Beacon",
																		   major: "3",
																		   minor: "",
																		   title: nil,
																		   message: "Wallet, Pasmo",
																		   notifyOnExit: true,
																		   notifyOnEnter: false))
		{ throwError in
			error = throwError as? ValidationError
		}
		
		XCTAssertEqual(expectedError, error)
	}
	
	func test_empty_notification_message_should_throw_notificationMessageRequired_error() throws {
		let expectedError = ValidationError.notificationMessageRequired
		var error: ValidationError?
		
		let validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
		
		XCTAssertThrowsError(try self.validationService.createSteppingBeacon(id: validUUIDStr,
																		   name: "Test Beacon",
																		   major: "3",
																		   minor: "1",
																		   title: nil,
																		   message: " ",
																		   notifyOnExit: true,
																		   notifyOnEnter: false))
		{ throwError in
			error = throwError as? ValidationError
		}
		
		XCTAssertEqual(expectedError, error)
	}
	
	func test_at_least_one_notification_action_selected() throws {
		let expectedError = ValidationError.atLeastOneEventRequired
		var error: ValidationError?
		
		let validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
		
		XCTAssertThrowsError(try self.validationService.createSteppingBeacon(id: validUUIDStr,
																		   name: "Test Beacon",
																		   major: "3",
																		   minor: "1",
																		   title: nil,
																		   message: "Wallet Passmo",
																		   notifyOnExit: false,
																		   notifyOnEnter: false))
		{ throwError in
			error = throwError as? ValidationError
		}
		
		XCTAssertEqual(expectedError, error)
	}
	
	func test_empty_notification_title_should_assigned_a_default_title() throws {
		
		let validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
		let name = "Test Beacon"
		let expectedTitle = "Did you forget something from \(name)?"
		
		let result = try self.validationService.createSteppingBeacon(id: validUUIDStr,
																   name: name,
																   major: "3",
																   minor: "1",
																   title: nil,
																   message: "Wallet Pasmo",
																   notifyOnExit: true,
																   notifyOnEnter: false)
		XCTAssertEqual(result.title, expectedTitle)
	}
}
