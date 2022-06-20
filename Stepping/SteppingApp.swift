//
//  SteppingApp.swift
//  Stepping
//
//  Created by Neso on 2020/09/23.
//

import SwiftUI

@main
struct SteppingApp: App {
    let persistenceController = PersistenceService.shared
    
    let userSettings = UserSettings()
    let permissionService = PermissionService()
    
    var body: some Scene {
        WindowGroup {
            Home().environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(userSettings)
                .environmentObject(permissionService)
        }
    }
}
