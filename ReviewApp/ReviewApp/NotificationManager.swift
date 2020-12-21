//
//  NotificationManager.swift
//  ReviewApp
//
//  Created by Y on 2020/11/08.
//

import Foundation
import UserNotifications

struct Notification {
    var id: String
    var title: String
}

class NotificationManager {
    static let shared = NotificationManager()
    var notifications = [Notification]()
    
    func requestPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print(" User gave permissions for local notifications")
            }
        }
    }
    
    func addNotification(title: String) {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }
    
    func schedule(hour: Int, minute: Int) -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications(hour, minute)
            default:
                break
            }
        }
    }
    
    func scheduleNotifications(_ hour: Int, _ minute: Int) {
        
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = "ReLeDiary"
            content.sound = UNNotificationSound.default
            content.body = "오늘의 복습일정을 확인해주세요 :)"
           
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id , content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if error != nil {
                    print("Error = \(error?.localizedDescription ?? "error local notification")")
                }
            }
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
