//
//  Home.swift
//  Stepping
//
//  Created by Neso on 2020/10/06.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var permissionService: PermissionService
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @State var showSplash = true
    
    var body: some View {
        VStack {
            if showSplash {
                SplashView()
            } else {
                if userSettings.firstLaunch {
                    Launch()
                        .environmentObject(userSettings)
                } else {
                    ContentView()
                        .environment(\.managedObjectContext, viewContext)
                        .environmentObject(permissionService)
                }
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    self.showSplash = false
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
