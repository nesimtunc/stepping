//
//  SteppingBeacon.swift
//  Stepping
//
//  Created by Neso on 2020/09/29.
//

import Foundation

struct SteppingBeacon {
	var uuid: UUID!
	var name = ""
	var major = Int16(0)
	var minor = Int16(0)
	// Notification related properties
	var title = ""
	var message = ""
	var notifyOnEnter = false
	var notifyOnExit = false
}
