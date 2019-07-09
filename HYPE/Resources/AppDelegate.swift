//
//  AppDelegate.swift
//  HYPE
//
//  Created by Madison Kaori Shino on 7/9/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //NOTIFICATION REQUEST
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (userDidAllow, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
            }
            if userDidAllow == true {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        //TESTING
        //        let testHype = "TESTING!"
        //        let hype = HypeController()
        //        hype.saveHype(text: testHype) { (success) in
        //            if success {
        //                print("it worked")
        //            }
        //        }
        //        hype.fetchHype { (success) in
        //            for hype in hype.hypes {
        //                print(hype.hypeText)
        //            }
        //        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        HypeController.sharedInstance.subscribeToRemoteNotifications { (error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error Registering APNS: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        HypeController.sharedInstance.fetchHype { (success) in
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}
