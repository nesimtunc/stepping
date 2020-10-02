//
//  NotificationService.swift
//  Stepping
//
//  Created by Neso on 2020/10/01.
//

import Foundation
import UserNotifications

class NotificationService: NSObject, ObservableObject {
	
	@Published private (set) var permissionGranted = false
	
	override init() {
		super.init()
		self.requestPermission()
	}
	
	func requestPermission() {
		let notification = UNUserNotificationCenter.current()
		let options: UNAuthorizationOptions = [.alert, .sound]
		
		notification.requestAuthorization(options: options) { didAllow, _ in
			DispatchQueue.main.async {
				self.permissionGranted = didAllow
			}
		}
		checkAuthorization()
	}
	
	func checkAuthorization() {
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			DispatchQueue.main.async {
				self.permissionGranted = settings.authorizationStatus == .authorized
			}
		}
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
