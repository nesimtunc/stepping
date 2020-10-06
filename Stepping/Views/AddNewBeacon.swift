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

	@State private var theBeacon =
		SteppingBeacon(beacon: Beacon(uuid: "",
									  name: "",
									  major: "",
									  minor: ""),
					   enterAction: Action(eventType: .enter,
										   title: "",
										   message: "",
										   shouldNotify: true),
					   exitAction: Action(eventType:
											.exit,
										  title: "",
										  message: "",
										  shouldNotify: true))

	@State private var notifyOnEnter = false
	@State private var notifyOnExit = true
	
	@State private var errorMessage = ""
	@State private var showingAlert = false
	
	var sessionController: SessionController!
	
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("iBeacon"), content: {
					TextField("Name ex: My Room", text: $theBeacon.beacon.name).accessibility(identifier: "name")
					TextField("Beacon UUID", text: $theBeacon.beacon.uuid).accessibility(identifier: "uuid")
					TextField("Major ex: 3", text: $theBeacon.beacon.major).accessibility(identifier: "major")
					TextField("Minor ex: 1", text: $theBeacon.beacon.minor).accessibility(identifier: "minor")
				})

				Toggle(isOn: $notifyOnEnter.animation()) {
					Text("Notify On Enter")
				}
				if (notifyOnEnter) {
					Section(header: Text("Notification for entering the area"), content: {
						TextField("Title", text: $theBeacon.enterAction.title)
						TextField("Message", text: $theBeacon.enterAction.message).accessibility(identifier: "message")
					})
				}

				Toggle(isOn: $notifyOnExit.animation()) {
					Text("Notify On Exit")
				}

				if (notifyOnExit) {
					Section(header: Text("Notification for exiting the area"), content: {
						TextField("Title", text: $theBeacon.exitAction.title)
						TextField("Message", text: $theBeacon.exitAction.message).accessibility(identifier: "message")
					})
				}

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
		theBeacon.beacon.name.isEmpty || theBeacon.beacon.uuid.isEmpty || theBeacon.beacon.major.isEmpty || theBeacon.beacon.minor.isEmpty
	}
	
	private func addItem() {
		errorMessage = ""
		showingAlert = false

		do {
			try theBeacon.validate()
		} catch {
			let nsError = error as NSError
			errorMessage = nsError.localizedDescription
			showingAlert = true
			return
		}
		
		withAnimation {
			let newItem = BeaconItem(context: viewContext)
			newItem.uuid = UUID(uuidString: theBeacon.beacon.uuid)
			newItem.name = theBeacon.beacon.name
			newItem.major = Int16(theBeacon.beacon.major)!
			newItem.minor = Int16(theBeacon.beacon.minor)!

			newItem.notifyOnExit = notifyOnExit
			newItem.notifyOnEnter = notifyOnEnter

			if (notifyOnExit) {
				//TODO: Change here after UI
				newItem.exitTitle = theBeacon.exitAction.title
				newItem.exitMessage = theBeacon.exitAction.message
			}

			if (notifyOnEnter) {
				//TODO: Change here after UI

				newItem.enterTitle = theBeacon.enterAction.title
				newItem.enterMessage = theBeacon.enterAction.message
			}

			newItem.notifyOnExit = notifyOnExit
			newItem.notifyOnEnter = notifyOnEnter
			newItem.timestamp = Date()

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
