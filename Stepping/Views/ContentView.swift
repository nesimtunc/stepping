//
//  ContentView.swift
//  Stepping
//
//  Created by Neso on 2020/09/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var permissionService: PermissionService
    
    @State private var showingAddScreen = false
    
    @State private var showingAlert = false
    @State private var errorMessage = ""
    
    private let session = SessionController()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BeaconItem.timestamp, ascending: false)],
        animation: .default)
    
    private var items: FetchedResults<BeaconItem>
    private var maxBeaconCount = 10
    
    var body: some View {
        NavigationView {
            VStack {
                if (items.count == 0) {
                    EmptyBeaconView()
                } else {
                    RemaingBeaconCount(count: items.count, maxBeaconCount: maxBeaconCount)
                    List {
                        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                            BeaconItemCell(index:index, item:item, session: self.session).accessibility(identifier: "\(String(describing: item.name))")
                        }
                        .onDelete(perform: deleteItems)
                    }.accessibility(identifier: "list")
                }
            }
            .navigationBarTitle("My iBeacons")
            .navigationBarItems(trailing: Button(action: {
                self.showingAddScreen.toggle()
            })  {
                if (items.count < 10)
                {
                    Image(systemName: "plus")
                }
            }
                .font(.title2))
            .sheet(isPresented: $showingAddScreen, content: {
                AddNewBeacon(sessionController: self.session).environment(\.managedObjectContext, self.viewContext)
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Warning"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $permissionService.notificationPermissionDenied) {
                Alert(title: Text("Push notification is disabled"), message: Text("In order to get notification you need to enable notification for the app. Pressing OK will open the settings screen."), dismissButton: .default(Text("OK")) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
            }
            .alert(isPresented: $permissionService.locationPermissionDenied) {
                Alert(title: Text("Location usage is disabled"), message: Text("In order to monitoring the iBeacons in background you need to allow the app using the location \"Always\" and precise on. Pressing OK will open the settings screen."), dismissButton: .default(Text("OK")) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        errorMessage = ""
        showingAlert = false
        
        withAnimation {
            offsets.map { items[$0] }.forEach { (item) in
                session.stopMonitoring(beaconItem: item)
                viewContext.delete(item)
            }
            
            do {
                try viewContext.save()
            } catch {
                errorMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }
}

struct BeaconItemCell: View {
    let index: Int
    let item: BeaconItem
    let session: SessionController
    
    var body: some View {
        NavigationLink(destination: BeaconItemDetail(item: item, beaconDetector: session.beaconDetector)) {
            VStack {
                HStack {
                    Label("", systemImage: "\(index + 1).circle")
                        .font(.title)
                    
                    VStack {
                        Text("\(item.name ?? "")")
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                            .lineLimit(0)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(item.uuid?.uuidString ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(0)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Text("Major:")
                                .font(.headline)
                            Text("\(item.major)")
                                .font(.subheadline)
                            Text("Minor:")
                                .font(.headline)
                            Text("\(item.minor)")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
}

struct EmptyBeaconView: View {
    var body: some View {
        Spacer()
        Text("You haven't created any iBeacon.\nYou can add up to 10 iBeacons to monitor.")
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding([.all])
        Spacer()
    }
}

struct RemaingBeaconCount: View {
    var count = 0
    var maxBeaconCount = 0
    
    var body: some View {
        if count == 10 {
            Text("You have reached maximum monitoring count.")
                .foregroundColor(.secondary)
        }
        else {	Text("You can add \(maxBeaconCount - count) more iBeacon(s) to monitor.")
                .foregroundColor(.secondary)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewDevice("iPhone 11 Pro Max").preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceService.preview.container.viewContext)
            ContentView().previewDevice("iPhone 11 Pro Max").preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceService.fullOfDataPreview.container.viewContext)
        }
    }
}
