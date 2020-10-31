//
//  PermissionsService.swift
//  Stepping
//
//  Created by Nesim Tunç on 2020/10/31.
//

import Foundation
import Combine
import UserNotifications

class PermissionService: ObservableObject {
    
    @Published var notificationPermissionDenied = false
    
    init() {
        checkAuthorization()
    }
    
    func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.notificationPermissionDenied = settings.authorizationStatus != .authorized
            }
        }
    }
}
