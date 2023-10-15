//
//  AppDelegate.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 14/07/23.
//
import Foundation
import UIKit
import CoreData
import UserNotifications
import OSLog
import MoEngageSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MoEngageMessagingDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Add your MoEngage App ID and Data center.
        let sdkConfig = MoEngageSDKConfig(appId: Constants.appID , dataCenter: .data_center_01);
        sdkConfig.enableLogs = true
        sdkConfig.appGroupID = Constants.appGroupID
        // MoEngage SDK Initialization
        // Separate initialization methods for Dev and Prod initializations
#if DEBUG
        MoEngage.sharedInstance.initializeDefaultTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeDefaultLiveInstance(sdkConfig)
#endif
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            guard success else{
                LogManager.error("Error in APNS registry: \(String(describing: error))")
                return
            }
            LogManager.logging("Success in APNS registry.")
        }
        // UIApplication.shared.registerForRemoteNotifications()
        let categoriesNotification = ActionableNotificationManager.configureActionableNotification()
        MoEngageSDKMessaging.sharedInstance.registerForRemoteNotification(withCategories: categoriesNotification, andUserNotificationCenterDelegate: self)
        MoEngageSDKMessaging.sharedInstance.setMessagingDelegate(self)
        //MARK: - Actionable Notification Types
        return true
    }
   
    //Method for Processing Notification Clicked.
    func notificationClicked(withScreenName screenName: String?, kvPairs: [AnyHashable : Any]?, andPushPayload userInfo: [AnyHashable : Any]) {
        
        print("Push Payload: \(userInfo)")
        
        if let actionKVPairs = kvPairs {
            print("Selected Action KVPair:\(actionKVPairs)")
        }
        
        if let screenName = screenName {
            print("Navigate to Screen:\(screenName)")
            NavigatingToScreen.navigatingToOtherScreen(toScreen: screenName)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Perform the task associated with the action.
//                switch response.actionIdentifier {
//                case "ACCEPT_ACTION":
//                    print("Accepted Invitation.")
//                    break
//                case "DECLINE_ACTION":
//                    print("Declined Invitation")
//                    break
//                case "BOOK":
//                    print("Tickets booked.")
//                    break
//                default:
//                    break
//                }
//
        MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, didReceive: response)
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.banner])
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        MoEngageSDKMessaging.sharedInstance.setPushToken(deviceToken)
        LogManager.logging("Device Token: \(token)")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        LogManager.error("Error in registering for Remote Notifications: \(error)")
    }
    
    //DeepLink Processing for custom URL Link
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Determine who sent the URL.
       
        return true
    }
    
    //DeepLink Processing for Universal Link
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool{
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb ,
           let incomingURL = userActivity.webpageURL{
            MoEngageSDKAnalytics.sharedInstance.processURL(incomingURL)
            print("incomingURL: \(incomingURL)")
        }
        return true;
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        let coreDataConfiguration = CoreDataConfiguration.shared
        coreDataConfiguration.saveContext()
    }
    
}

