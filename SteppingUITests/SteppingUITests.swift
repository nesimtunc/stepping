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

		let tablesQuery = app.tables

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

	func testLaunchPerformance() throws {
		if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
			// This measures how long it takes to launch your application.
			measure(metrics: [XCTApplicationLaunchMetric()]) {
				XCUIApplication().launch()
			}
		}
	}
}
