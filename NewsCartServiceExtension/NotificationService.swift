//
//  NotificationService.swift
//  NewsCartServiceExtension
//
//  Created by UdayKiran Naik on 02/08/23.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
        //    let userInfo = bestAttemptContent.userInfo as! [String:Any]
            bestAttemptContent.title = "NewsCart here..!!"
            bestAttemptContent.subtitle = "We are from Banglore"
            bestAttemptContent.body = "30% off for this Independence Day sales⚡️"
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            bestAttemptContent.title = "NewsCart here...!!"
            contentHandler(bestAttemptContent)
        }
    }

}