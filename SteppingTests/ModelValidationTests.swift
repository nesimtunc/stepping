//
//  ValidationService.swift
//  SteppingTests
//
//  Created by Neso on 2020/09/29.
//

import XCTest
@testable import Stepping

class ModelValidationTests: XCTestCase {

	func test_empty_Beacon_UUID_should_throw_invalidUUID_error() throws {
		let expectedError = ValidationError.invalidUUID
		var error: ValidationError?

		let testBeacon = SteppingBeacon(beacon: Beacon(uuid: "invalid uuid",
													   name: "Test Becaon",
													   major: "3",
													   minor: "1"),
										enterAction: nil,
										exitAction: nil)

		XCTAssertThrowsError(try testBeacon.validate())
		{ throwError in
			error = throwError as? ValidationError
		}
		
		XCTAssertEqual(expectedError, error)
	}
	
	func test_empty_Beacon_name_should_throw_nameRequired_error() throws {
		let expectedError = ValidationError.nameRequired
		var error: ValidationError?
		
		let validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
		let testBeacon = SteppingBeacon(beacon: Beacon(uuid: validUUIDStr,
													   name: " ",
													   major: "3",
													   minor: "1"),
										enterAction: Action(eventType: .exit,
															title: "",
															message: "Wallet, Keys?",
															shouldNotify: true),
										exitAction: nil)
		
		XCTAssertThrowsError(try testBeacon.validate())
		{ throwError in
			error = throwError as? ValidationError
		}
		
		XCTAssertEqual(expectedError, error)
	}
	
	func test_invalid_Beacon_major_no_should_throw_invalidMajor_error() throws {
		let expectedError = ValidationError.invalidMajor
		var error: ValidationError?
		
		let validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
		let testBeacon = SteppingBeacon(beacon: Beacon(uuid: validUUIDStr,
													   name: "Test Beacon",
													   major: "",
													   minor: "1"),
										enterAction: nil,
										exitAction:  Action(eventType: .exit,
															title: "",
															message: "Wallet, Keys?",
															shouldNotify: true))

		XCTAssertThrowsError(try testBeacon.validate())
		{ throwError in
			error = throwError as? ValidationError
		}
		
		XCTAssertEqual(expectedError, error)
	}
	
	
	func test_invalid_Beacon_minor_no_should_throw_invalidMinor_error() throws {
		let expectedError = ValidationError.invalidMinor
		var error: ValidationError?
		
		let validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
		let testBeacon = SteppingBeacon(beacon: Beacon(uuid: validUUIDStr,
													   name: "Test Beacon",
													   major: "3",
													   minor: ""),
										enterAction: nil,
										exitAction:  Action(eventType: .exit,
															title: "",
															message: "Wallet, Keys?",
															shouldNotify: true))
		
		XCTAssertThrowsError(try testBeacon.validate())
		{ throwError in
			error = throwError as? ValidationError
		}
		
		XCTAssertEqual(expectedError, error)
	}
	
	func test_empty_notification_message_should_throw_notificationMessageRequired_error() throws {
		let expectedError = ValidationError.notificationMessageRequired
		var error: ValidationError?
		
		let validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
		let testBeacon = SteppingBeacon(beacon: Beacon(uuid: validUUIDStr,
													   name: "Test Beacon",
													   major: "3",
													   minor: "1"),
										enterAction: nil,
										exitAction:  Action(eventType: .exit,
															title: "",
															message: " ",
															shouldNotify: true))

		XCTAssertThrowsError(try testBeacon.validate())
		{ throwError in
			error = throwError as? ValidationError
		}
		
		XCTAssertEqual(expectedError, error)
	}
	
	func test_at_no_notification_action_selected() throws {
		let expectedError = ValidationError.atLeastOneEventRequired
		var error: ValidationError?
		
		let validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
		let testBeacon = SteppingBeacon(beacon: Beacon(uuid: validUUIDStr,
													   name: "Test Beacon",
													   major: "3",
													   minor: "1"),
										enterAction: nil,
										exitAction:  nil)
		
		XCTAssertThrowsError(try testBeacon.validate())
		{ throwError in
			error = throwError as? ValidationError
		}
		
		XCTAssertEqual(expectedError, error)
	}

	func test_at_least_one_notification_action_selected() throws {

		let validUUIDStr = "77048D46-2AB4-44B2-9C72-2764B8A899C5"
		let testBeacon = SteppingBeacon(beacon: Beacon(uuid: validUUIDStr,
													   name: "Test Beacon",
													   major: "3",
													   minor: "1"),
										enterAction: nil,
										exitAction:  Action(eventType: .exit,
															title: "",
															message: "Hello did you forget something?",
															shouldNotify: true))

		XCTAssertNoThrow(try testBeacon.validate())
	}
}
