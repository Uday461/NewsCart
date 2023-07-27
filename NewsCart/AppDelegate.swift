//
//  AppDelegate.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 14/07/23.
//

import UIKit
import CoreData
//import Firebase
//import FirebaseMessaging
//import UserNotifications
//Protocols: MessagingDelegate, UNUserNotificationCenterDelegate
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        UNUserNotificationCenter.current().delegate = self
//
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
//            guard success else{
//                print("Error in APNS registry: \(String(describing: error))")
//                return
//            }
//            print("Success in APNS registry.")
//        }
//        application.registerForRemoteNotifications()
        UIApplication.shared.registerForRemoteNotifications()
        return true
    }
   
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successful Registration for Remote Notifications: \(deviceToken)")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error in registering for Remote Notifications: \(error)")
    }
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        messaging.token { token, error in
//            guard let token = token else{
//                print("Error in token generation: \(String(describing: error))")
//                return
//            }
//            print("Token: \(token)")
//        }
//    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsCart")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

