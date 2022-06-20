//
//  Launch.swift
//  Stepping
//
//  Created by Neso on 2020/10/06.
//

import SwiftUI

struct Launch: View {
    
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        VStack {
            Image("Launcher")
                .resizable()
                .frame(width: 128, height: 128)
            
            Text("Stepping").modifier(BigText())
                .padding()
            Text("Never forget anything before stepping in or out of your house.")
                .italic()
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("In order to Stepping works properly you need allow the location request to \"Always\" and enable push notifications to be notified on enter and exit.")
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .padding(.top, 10.0)
                .padding(.horizontal, 20.0)
            
            Button("Okay!") {
                UserDefaults.standard.setValue("done", forKey: "firstLaunch")
                userSettings.firstLaunch = false
            }.padding([.top], 36)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct Launch_Previews: PreviewProvider {
    static var previews: some View {
        Launch()
    }
}
