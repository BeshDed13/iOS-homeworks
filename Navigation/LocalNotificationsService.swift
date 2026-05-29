//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 11.03.2026.
//

import UserNotifications

final class LocalNotificationsService {
    
    func registeForLatestUpdatesIfPossible() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.scheduleLatestUpdatesNotification()
            }
        }
    }
    
    func scheduleLatestUpdatesNotification() {
        let content = UNMutableNotificationContent()
        content.title = "New Updates"
        content.body = "Check out the latest updates!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0
        
        #if DEBUG
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        #else
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        #endif
        
        let request = UNNotificationRequest(identifier: "LatestUpdates", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
