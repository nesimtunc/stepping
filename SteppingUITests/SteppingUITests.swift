//
//  SteppingUITests.swift
//  SteppingUITests
//
//  Created by Neso on 2020/09/23.
//

import XCTest

class SteppingUITests: XCTestCase {

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.

		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false

		// In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testAddNewBeacon() throws {
		// UI tests must launch the application that they test.
		let app = XCUIApplication()

		app.launch()

		app.navigationBars["My iBeacons"].buttons["plus"].tap()

		let tablesQuery2 = app.tables
		let tablesQuery = tablesQuery2

		let name = tablesQuery/*@START_MENU_TOKEN@*/.textFields["name"]/*[[".cells[\"Name ex: My Room\"]",".textFields[\"Name ex: My Room\"]",".textFields[\"name\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
		name.tap()
		name.typeText("Test")

		let uuid = tablesQuery.textFields["uuid"]
		uuid.tap()
		uuid.typeText("4AD3F9C4-EEA0-4067-93B9-30591748A143")

		let major = tablesQuery.textFields["major"]
		major.tap()
		major.typeText("3")

		let minor = tablesQuery.textFields["minor"]
		minor.tap()
		minor.typeText("1")

		app.swipeUp()

		let message = tablesQuery.textFields["message"]
		message.tap()
		message.typeText("Wallet, Keys?")

		let save = tablesQuery.buttons["save"]
		save.tap()
	}

	func testBeaconDetail() throws {

		let app = XCUIApplication()
		app.launch()

		app.tables["list"]/*@START_MENU_TOKEN@*/.buttons["Optional(\"Test\")"]/*[[".cells[\"Test\\n4AD3F9C4-EEA0-4067-93B9-30591748A143\\nMajor:\\n3\\nMinor:\\n1\"]",".buttons[\"Test\\n4AD3F9C4-EEA0-4067-93B9-30591748A143\\nMajor:\\n3\\nMinor:\\n1\"]",".buttons[\"Optional(\\\"Test\\\")\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
		app.navigationBars.buttons["My iBeacons"].tap()

	}

	func testDeleteBeacon() throws {

		let app = XCUIApplication()
		app.launch()

		let listTable = app.tables["list"]
		XCTAssertEqual(listTable.cells.count, 1)
		listTable/*@START_MENU_TOKEN@*/.buttons["Optional(\"Test\")"]/*[[".cells[\"Test\\n4AD3F9C4-EEA0-4067-93B9-30591748A143\\nMajor:\\n3\\nMinor:\\n1\"]",".buttons[\"Test\\n4AD3F9C4-EEA0-4067-93B9-30591748A143\\nMajor:\\n3\\nMinor:\\n1\"]",".buttons[\"Optional(\\\"Test\\\")\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
		listTable/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells[\"Test\\n4AD3F9C4-EEA0-4067-93B9-30591748A143\\nMajor:\\n3\\nMinor:\\n1\"].buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

	}
}
