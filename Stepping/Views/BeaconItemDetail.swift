//
//  BeaconItemDetail.swift
//  Stepping
//
//  Created by Neso on 2020/10/02.
//

import SwiftUI
import CoreLocation

struct BeaconItemDetail: View {
	var item: BeaconItem
	@ObservedObject var beaconDetector: BeaconDetector
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16.0) {
			DetailView(item: item, beacon: beaconDetector.foundBeacons[item.uuid!])
			Spacer()
		}
		.padding(.all)
	}
}

struct DetailView: View {
	var item: BeaconItem
	var beacon: CLBeacon!
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16.0) {
			
			Text(item.name!)
				.font(.title)
			Text(item.uuid!.uuidString)
				.font(.subheadline)
				.foregroundColor(.secondary)
			
			Text("Notification:")
//			Text(item.title!)
//			Text(item.message!)

			if beacon != nil {
				BeaconView(beacon: beacon)
			}
		}
	}
}

struct BeaconView: View {

	var beacon: CLBeacon

	var body: some View {
		Text("Rssi: \(beacon.rssi)")
		Text("Promixty:")
		Text("\(getPromixityText(beacon.proximity))")
			.font(Font.system(size: 40, weight: .medium, design: .rounded))

		ProgressView(value: getProgressViewValue(beacon.proximity))
			.accentColor(getProgressViewColor(beacon.proximity))
	}

	private func getPromixityText(_ proximity: CLProximity) -> String {
		switch proximity {
			case .far:
				return "FAR"
			case .immediate:
				return "IMMEDIATE"
			case .near:
				return "NEAR"
			case .unknown:
				return "NOT FOUND"
			@unknown default:
				return "UNKNOWN"
		}
	}

	private func getProgressViewValue(_ proximity: CLProximity) -> Double {
		switch proximity {
			case .far:
				return 0.25
			case .near:
				return 0.5
			case .immediate:
				return 1.0
			case .unknown:
				return 0.0
			@unknown default:
				return 0.0
		}
	}

	private func getProgressViewColor(_ proximity: CLProximity) -> Color {
		switch proximity {
			case .far:
				return .yellow
			case .near:
				return .orange
			case .immediate:
				return .green
			case .unknown:
				return .gray
			@unknown default:
				return .gray
		}
	}
}
