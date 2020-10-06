//
//  Home.swift
//  Stepping
//
//  Created by Neso on 2020/10/06.
//

import SwiftUI

struct Home: View {

	@EnvironmentObject var userSettings: UserSettings
	@Environment(\.managedObjectContext) private var viewContext

    var body: some View {
		if userSettings.firstLaunch {
			Launch()
				.environmentObject(userSettings)
		} else {
			ContentView()
				.environment(\.managedObjectContext, viewContext)
		}
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
