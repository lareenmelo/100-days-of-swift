//
//  ViewController.swift
//  Project21
//
//  Created by Lareen Melo on 12/5/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        // challenge #2
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(initialTime))
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }

    // challenge #2
    @objc func initialTime() {
        scheduleLocal(timeInterval: 60)
    }
    
    @objc func scheduleLocal(timeInterval: TimeInterval) {
        registerCategories()

        let center = UNUserNotificationCenter.current()

        // not required, but useful for testing!
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // challenge #2
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        // challenge #2
        let later = UNNotificationAction(identifier: "later", title: "Remind me later", options: .authenticationRequired)
        // authenticationRequired so app doesn't open
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, later], intentIdentifiers: [])

        center.setNotificationCategories([category])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock; do nothing
                showAlert(message: "SWIPED TO UNLOCK SELECTED")

            case "show":
                showAlert(message: "SHOW MORE INFORMATION SELECTED")
           
            // challenge #2
            case "later":
                showAlert(message: "REMIND ME LATER SELECTED")
                scheduleLocal(timeInterval: 86400)
                
            default:
                break
            }
        }

        // you need to call the completion handler when you're done
        completionHandler()
    }
    
    // Challenge #1
    func showAlert(message: String) {
        let ac = UIAlertController(title: "Action Selected", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Done", style: .cancel))
        
        present(ac, animated: true)
    }
}
