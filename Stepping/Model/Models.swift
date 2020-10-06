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

		//TODO: check on multiple action
		//		if message.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
		//			throw ValidationError.notificationMessageRequired
		//		}

		if !self.exitAction.shouldNotify && !self.enterAction.shouldNotify {
			throw ValidationError.atLeastOneEventRequired
		}

		//		var result = SteppingBeacon()
		//		result.beacon = Beacon(uuid: uuid.uuidString, name: name, major: "\(parsedMajor)", minor: "\(parsedMinor)")
		//
		//		if (self.notifyOnExit) {
		//			result.exitAction = Action(eventType: .exit, title: title ?? "You're about to leave \(name)?", message: message, shouldNotify: true)
		//		}
		//
		//		if (notifyOnEnter) {
		//			result.enterAction = Action(eventType: .enter, title: title ?? "You're entering to \(name)?", message: message, shouldNotify: true)
		//		}

	}
}
