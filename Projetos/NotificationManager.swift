//
//  NotificationManager.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 21/08/26.
//
import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func scheduleTaskNotification(taskId: UUID?, title: String, endDate: Date, option: NotificationOptions) {
        guard let taskId = taskId, option != .never else { return }

        let content = UNMutableNotificationContent()
        content.title = "⭐Lembre-se: \(title)"
        content.body = "Sua tarefa precisa da sua atenção!"
        content.sound = .default

        let calendar = Calendar.current

        switch option {
        case .never:
            return

        case .daily:
           
            let components = calendar.dateComponents([.hour, .minute], from: endDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            scheduleRequest(id: taskId.uuidString, content: content, trigger: trigger)

        case .weekDay:
            let timeComponents = calendar.dateComponents([.hour, .minute], from: endDate)
            for weekday in 2...6 {
                var components = timeComponents
                components.weekday = weekday
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                scheduleRequest(id: "\(taskId.uuidString)-weekday-\(weekday)", content: content, trigger: trigger)
            }

        case .weekend:
          
            let timeComponents = calendar.dateComponents([.hour, .minute], from: endDate)
            for weekday in [1, 7] {
                var components = timeComponents
                components.weekday = weekday
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                scheduleRequest(id: "\(taskId.uuidString)-weekend-\(weekday)", content: content, trigger: trigger)
            }

        case .fortnightly:
      
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 14 * 24 * 60 * 60, repeats: true)
            scheduleRequest(id: taskId.uuidString, content: content, trigger: trigger)

        case .monthly:
            let components = calendar.dateComponents([.day, .hour, .minute], from: endDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            scheduleRequest(id: taskId.uuidString, content: content, trigger: trigger)
        }
    }

    private func scheduleRequest(id: String, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func cancelNotification(taskId: UUID?) {
        guard let taskId = taskId else { return }
      
        let identifiers = [taskId.uuidString] + (1...7).map { "\(taskId.uuidString)-weekday-\($0)" } + (1...7).map { "\(taskId.uuidString)-weekend-\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
