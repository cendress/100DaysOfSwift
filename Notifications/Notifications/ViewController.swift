//
//  ViewController.swift
//  Notifications
//
//  Created by Christopher Endress on 12/11/23.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
  }
  
  @objc func registerLocal() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if granted {
        print("Yay!")
      } else {
        print("Oh no!")
      }
    }
  }
  
  @objc func scheduleLocal(delay interval: TimeInterval = 0) {
    registerCategories()
    
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()
    
    let content = UNMutableNotificationContent()
    content.title = "Late wake up call"
    content.body = "The early bird catches the worm, but the second mouse gets the cheese."
    content.categoryIdentifier = "alarm"
    content.userInfo = ["customData": "fizzbuzz"]
    content.sound = .default
    
    var dateComponents = DateComponents()
    dateComponents.hour = 10
    dateComponents.minute = 30
    //    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let trigger: UNNotificationTrigger
    if interval > 0 {
      trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
    } else {
      trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    }
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
  }
  
  func registerCategories() {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    
    let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
    let remind = UNNotificationAction(identifier: "remind", title: "Remind me later", options: .foreground)
    let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [], options: [])
    
    center.setNotificationCategories([category])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    
    if let customData = userInfo["customData"] as? String {
      print("Custom data received: \(customData)")
      
      var ac = UIAlertController()
      
      switch response.actionIdentifier {
      case UNNotificationDefaultActionIdentifier:
        print("Default identifier")
        ac = UIAlertController(title: "Default", message: "This is the default identifier", preferredStyle: .alert)
      case "show":
        print("Show more information")
        ac = UIAlertController(title: "Show", message: "This is showing more information", preferredStyle: .alert)
      case "remindLater":
        scheduleLocal(delay: 86400)
      default:
        ac = UIAlertController(title: "Unknown Case", message: "This is an unknown use case", preferredStyle: .alert)
        break
      }
      
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      
      DispatchQueue.main.async {
        self.present(ac, animated: true)
      }
    }
    
    completionHandler()
  }
}

