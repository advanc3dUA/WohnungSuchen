//
//  NotificationsManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 20.04.2023.
//

import UserNotifications

enum NotificationType {
    case standart
    case custom
    
    var sound: UNNotificationSound {
        switch self {
        case .standart:
            return .default
        case .custom:
            return UNNotificationSound(named: UNNotificationSoundName("IntelPentiumSound.mp3"))
        }
    }
}

final class NotificationsManager {
    private var content: UNMutableNotificationContent
    private var notificationType: NotificationType
    
    init() {
        self.content = UNMutableNotificationContent()
        self.notificationType = .custom
        content.body = "tap to open app"
        content.sound = notificationType.sound
    }
    
    func pushNotification(for number: Int) {
        guard number > 0 else { return }
        content.sound = notificationType.sound
        content.title = "\(number) new result\(number == 1 ? "" : "s")"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "newApartmentNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    func setAlertType(to notificationType: NotificationType) {
        self.notificationType = notificationType
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            } else if !granted {
                print("Notification authorization not granted")
            } else {
                print("Notification authorization granted")
            }
        }
        center.removeAllPendingNotificationRequests()
    }
}
