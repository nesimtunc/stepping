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

	@State private var showingAddScreen = false

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
							BeaconItemCell(index:index, item:item)
						}
						.onDelete(perform: deleteItems)
					}
				}
			}
			.padding([.horizontal], -20)
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
				AddNewBeacon().environment(\.managedObjectContext, self.viewContext)
			})
		}
	}

	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			offsets.map { items[$0] }.forEach(viewContext.delete)

			do {
				try viewContext.save()
			} catch {
				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}
}

struct BeaconItemCell: View {
	var index: Int
	var item: BeaconItem
	var body: some View {
		NavigationLink(destination: Text(item.name ?? "")) {
			HStack {
				Label("", systemImage: "\(index + 1).circle")
					.font(.title)

				VStack {
					Text("\(item.name ?? "")")
						.font(.headline)
						.multilineTextAlignment(.leading)
						.lineLimit(0)
						.frame(maxWidth: .infinity, alignment: .leading)
					Text("\(item.id?.uuidString ?? "")")
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
			ContentView().previewDevice("iPhone 11 Pro Max").preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
			ContentView().previewDevice("iPhone 11 Pro Max").preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceController.fullOfDataPreview.container.viewContext)
		}
	}
}
