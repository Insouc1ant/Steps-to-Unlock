import Foundation
import UserNotifications

class NotificationManager {
    // 1. The shared instance (just like your ScreenTimeManager)
    static let shared = NotificationManager()
    
    // 2. Ask the user for permission to send alerts
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted!")
            } else if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
    
    // 3. The function to actually send a message
    func scheduleNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default // Plays the standard iPhone "ding"
        
        // Trigger the notification almost immediately (1 second delay)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Send it to the iOS system
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }
}
