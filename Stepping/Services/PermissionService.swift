//
//  PermissionsService.swift
//  Stepping
//
//  Created by Nesim Tunç on 2020/10/31.
//

import Foundation
import Combine
import UserNotifications
import CoreLocation

class PermissionService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var notificationPermissionDenied = false
    @Published var locationPermissionDenied = false
    
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        checkAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.notificationPermissionDenied = settings.authorizationStatus != .authorized
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.locationPermissionDenied = status != .authorizedAlways
        }
    }
}
