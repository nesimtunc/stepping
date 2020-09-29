//
//  ValidationService.swift
//  Stepping
//
//  Created by Neso on 2020/09/29.
//

import Foundation

struct ValidationService {

	func validateBeaconItem(id: String, name: String, major: String, minor: String, title: String?, message: String, notifyOnExit: Bool, notifyOnEnter: Bool)  throws -> SteppingBeacon {

		guard let uuid = UUID(uuidString: id)  else {
			throw ValidationError.invalidUUID
		}

		if name.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
			throw ValidationError.nameRequired
		}

		guard let parsedMajor = Int16(major) else {
			throw ValidationError.invalidMajor
		}

		guard let parsedMinor = Int16(minor) else {
			throw ValidationError.invalidMinor
		}

		if message.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
			throw ValidationError.notificationMessageRequired
		}

		if !notifyOnExit && !notifyOnExit {
			throw ValidationError.atLeastOneEventRequired
		}

		var result = SteppingBeacon()
		result.uuid = uuid
		result.name = name
		result.major = parsedMajor
		result.minor = parsedMinor
		result.title = title ?? "Did you forget something from \(name)?"
		result.message =  message
		result.notifyOnEnter = notifyOnEnter
		result.notifyOnExit = notifyOnExit
		return result
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
