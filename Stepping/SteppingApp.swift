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
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
		}
	}
}
