//
//  NotificationController.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 10/16/23.
//

import Foundation
import UserNotifications


extension DataController {
    func addReminder(for task: TaskItem) async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            switch settings.authorizationStatus {
            case .notDetermined:
                let success = try await requestNotifications()
                
                if success {
                    try await placeReminders(for: task)
                } else {
                    return false
                }
                
            case .authorized:
                try await placeReminders(for: task)
                
            default:
                return false
            }
            
            return true
        } catch {
            return false
        }
    }
    
    func removeReminders(for task: TaskItem) {
        let center = UNUserNotificationCenter.current()
        let id = task.objectID.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    private func requestNotifications() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        return try await center.requestAuthorization(options: [.alert, .sound])
    }
    
    private func placeReminders(for task: TaskItem) async throws {
        let content = UNMutableNotificationContent()
        content.title = task.taskTitle
        content.sound = .default
        
        if let taskContent = task.content {
            content.subtitle = taskContent
        }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: task.taskReminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let id = task.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        return try await UNUserNotificationCenter.current().add(request)
    }
}
