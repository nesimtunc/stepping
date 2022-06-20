//
//  NotificationService.swift
//  Stepping
//
//  Created by Neso on 2020/10/01.
//

import Foundation
import UserNotifications
import CoreData

class NotificationService: NSObject, ObservableObject {
    
    override init() {
        super.init()
        self.requestPermission()
    }
    
    func requestPermission() {
        let notification = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        notification.requestAuthorization(options: options) { _, _ in }
    }
    
    func show(pushNotificationId: String, title: String, message: String) {
        let push = UNMutableNotificationContent()
        push.title = title
        push.body = message
        push.sound = .default
        
        let request = UNNotificationRequest(identifier: "Stepping_\(pushNotificationId)", content: push, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
