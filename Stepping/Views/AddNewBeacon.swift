//
//  BeaconDetail.swift
//  Stepping
//
//  Created by Neso on 2020/09/24.
//

import SwiftUI
import CoreData

struct AddNewBeacon: View {
	
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.presentationMode) var presentationMode
	
	@State private var id = ""
	@State private var name = ""
	@State private var major = ""
	@State private var minor = ""
	@State private var title = ""
	@State private var message = ""
	@State private var notifyOnEnter = false
	@State private var notifyOnExit = true
	
	@State private var errorMessage = ""
	@State private var showingAlert = false
	
	var sessionController: SessionController!
	
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("iBeacon"), content: {
					TextField("Name ex: My Room", text: $name).accessibility(identifier: "name")
					TextField("UUID", text: $id).accessibility(identifier: "uuid")
					TextField("Major ex: 3", text: $major).accessibility(identifier: "major")
					TextField("Minor ex: 1", text: $minor).accessibility(identifier: "minor")
				})
				Section(header: Text("Notification"), content: {
					TextField("Title", text: $title)
					TextField("Message", text: $message).accessibility(identifier: "message")
					Toggle(isOn: $notifyOnEnter) {
						Text("Notify On Enter")
					}
					Toggle(isOn: $notifyOnExit) {
						Text("Notify On Exit")
					}
				})
				Section {
					Button("Save") {
						addItem()
						sessionController.updateMonitoring()
					}.disabled(shouldDisableSaveButton)
					.accessibility(identifier: "save")
				}
			}
			.navigationTitle("Add New iBeacon")
			.navigationBarItems(leading: Button(action: {
				self.presentationMode.wrappedValue.dismiss()
			}) {
				Text("Cancel")
			})
			.alert(isPresented: $showingAlert, content: {
				Alert(title: Text("Required field"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
			})
		}
	}
	
	var shouldDisableSaveButton : Bool {
		name.isEmpty || id.isEmpty || major.isEmpty || minor.isEmpty || message.isEmpty
	}
	
	private func addItem() {
		errorMessage = ""
		showingAlert = false
		
		let validationService = ValidationService()
		var result: SteppingBeacon!
		do {
			result = try validationService.validateBeaconItem(id: id, name: name, major: major, minor: minor, title: title, message: message, notifyOnExit: notifyOnExit, notifyOnEnter: notifyOnEnter)
		} catch {
			let nsError = error as NSError
			errorMessage = nsError.localizedDescription
			showingAlert = true
		}
		
		guard let beacon = result else {
			return
		}
		
		withAnimation {
			let newItem = BeaconItem(context: viewContext)
			newItem.uuid = beacon.uuid
			newItem.name = beacon.name
			newItem.major = beacon.major
			newItem.minor = beacon.minor
			newItem.title = title == "" ? "Did you forget something from \(beacon.name)" : beacon.title
			newItem.message = beacon.message
			newItem.timestamp = Date()
			newItem.notifyOnExit = beacon.notifyOnExit
			newItem.notifyOnEnter = beacon.notifyOnEnter
			
			do {
				try viewContext.save()
				self.presentationMode.wrappedValue.dismiss()
			} catch {
				let nsError = error as NSError
				errorMessage = nsError.localizedDescription
				showingAlert = true
			}
		}
	}
}

struct BeaconDetail_Previews: PreviewProvider {
	static var previews: some View {
		AddNewBeacon()
	}
}
