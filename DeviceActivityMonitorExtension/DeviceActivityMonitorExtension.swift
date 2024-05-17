//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitorExtension
//
//  Created by Longnn on 14/05/2024.
//

import DeviceActivity
import UserNotifications
import ManagedSettings

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
  func scheduleNotification(with title: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = title // Using the custom title here
                content.body = "Here is the body text of the notification."
                content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // 5 seconds from now

                let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)

                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    }
                }
            } else {
                print("Permission denied. \(error?.localizedDescription ?? "")")
            }
        }
    }
  let model = ScreenTimeSelectAppsModel.shared
      func showLocalNotification(title: String, desc: String) {
        let countSelectedAppToken =  model.countSelectedApp()
        let countSelectedCategoryToken =  model.countSelectedAppCategory()

          let content = UNMutableNotificationContent()
          content.title = title
          content.body = "Selected app: "+String(countSelectedAppToken)+" category: "+String(countSelectedCategoryToken)
          content.sound = .default

          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
          let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)

          UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
              print("Failed to show notification: \(error.localizedDescription)")
            }
          }

        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Failed to add notification: \(error)")
            } else {
                print("Success add notification")
            }
        }
    }
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
      scheduleNotification(with: "interval did start")

      let socialStore = ManagedSettingsStore(named: .mySettingStore)
      socialStore.clearAllSettings()
      model.startAppRestrictions()
        // Handle the start of the interval.
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        model.stopAppRestrictions()
        showLocalNotification(title: "My Restriction Stopped", desc: "Restriction App is stopped")
        // Handle the end of the interval.
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}
