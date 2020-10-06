//
//  SteppingBeacon.swift
//  Stepping
//
//  Created by Neso on 2020/09/29.
//

import Foundation

struct SteppingBeacon {
	var beacon: Beacon!
	var enterAction: Action!
	var exitAction: Action!
}

struct Beacon {
	var uuid = ""
	var name = ""
	var major = ""
	var minor = ""
}

struct Action {
	var eventType: EventType
	var title: String
	var message: String
	var shouldNotify: Bool
}

enum EventType {
	case exit
	case enter
}

extension SteppingBeacon {

	func validate()  throws  {

		guard UUID(uuidString: self.beacon.uuid) != nil  else {
			throw ValidationError.invalidUUID
		}

		if self.beacon.name.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
			throw ValidationError.nameRequired
		}

		guard Int16(self.beacon.major) != nil else {
			throw ValidationError.invalidMajor
		}

		guard Int16(self.beacon.minor) != nil else {
			throw ValidationError.invalidMinor
		}

		if (self.exitAction == nil && self.enterAction == nil) {
			throw ValidationError.atLeastOneEventRequired
		}

		if (!self.exitAction.shouldNotify && !self.enterAction.shouldNotify) {
			throw ValidationError.atLeastOneEventRequired
		}

		if (self.exitAction != nil &&  (self.exitAction!.shouldNotify && self.exitAction.message
			.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)) {
			throw ValidationError.notificationMessageRequired
		}

		if (self.enterAction != nil && (self.enterAction.shouldNotify && self.enterAction.message
			.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)) {
			throw ValidationError.notificationMessageRequired
		}
	}
}


enum ValidationError: LocalizedError {
	case invalidUUID
	case invalidMajor
	case invalidMinor
	case nameRequired
	case notificationMessageRequired
	case atLeastOneEventRequired

	var errorDescription: String? {
		switch self {
			case .invalidUUID:
				return "Invalid UUID for iBeacon"
			case .invalidMajor:
				return "Major can be only number. Think of floor number or a branch code"
			case .invalidMinor:
				return "Minor can be only number. Think of room number or a subbranch code"
			case .nameRequired:
				return "You need give a name to your iBeacon"
			case .notificationMessageRequired:
				return "A notification message is required"
			case .atLeastOneEventRequired:
				return "In order to get notification you need one at least choose on trigger action."
		}
	}
}
