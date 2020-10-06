//
//  UserSettings.swift
//  Stepping
//
//  Created by Neso on 2020/10/06.
//

import Foundation

class UserSettings: ObservableObject {
	@Published var firstLaunch: Bool

	init() {
		self.firstLaunch = UserDefaults.standard.string(forKey: "firstLaunch") == nil
	}
}
