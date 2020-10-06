//
//  SteppingApp.swift
//  Stepping
//
//  Created by Neso on 2020/09/23.
//

import SwiftUI

@main
struct SteppingApp: App {
	let persistenceController = PersistenceController.shared

	let userSettings = UserSettings()

	var body: some Scene {
		WindowGroup {
			Home().environment(\.managedObjectContext, persistenceController.container.viewContext)
				.environmentObject(userSettings)
		}
	}
}
