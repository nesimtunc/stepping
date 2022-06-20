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
        List {
            Section(header: Text("Beacon")) {
                RowItem(title: "UUID:", detail: item.uuid!.uuidString)
            }
            Section(header: Text("Notifications")) {
                if (item.notifyOnEnter) {
                    RowItem(title: "Enter Title", detail: item.enterTitle!)
                    RowItem(title: "Enter Message", detail: item.enterMessage!)
                }
                
                if (item.notifyOnExit) {
                    RowItem(title: "Exit Title", detail: item.exitTitle!)
                    RowItem(title: "Exit Message", detail: item.exitMessage!)
                }
            }
            
            if beacon != nil {
                Section(header:
                            Text("Status")) {
                    BeaconView(beacon: beacon)
                }
                
            }
        }.navigationTitle(item.name!)
        
    }
    
}

struct RowItem: View {
    var title = ""
    var detail = ""
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
        if detail.count > 0 {
            Text(detail)
                .multilineTextAlignment(.leading)
        }
    }
}

struct BeaconView: View {
    
    var beacon: CLBeacon
    
    var body: some View {
        RowItem(title: "Rssi", detail: "\(beacon.rssi)")
        RowItem(title: "Promixty", detail: "")
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
