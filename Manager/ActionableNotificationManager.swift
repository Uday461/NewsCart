//
//  ActionableNotificationManager.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 03/08/23.
//

import Foundation
import UserNotifications

class ActionableNotificationManager: UNUserNotificationCenter, UNUserNotificationCenterDelegate {
    static func configureActionableNotification(){
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_INVITATION",
                                                title: "Accept",
                                                options: [])
        let declineAction = UNNotificationAction(identifier: "DECLINE_INVITATION",
                                                 title: "Decline",
                                                 options: [])
        let book = UNNotificationAction(identifier: "BOOK",
                                        title: "Book Tickets Now",
                                        options: [])
        
        // Define the notification type
        let meetingInviteCategory =
        UNNotificationCategory(identifier: "MEETING_INVITATION",
                               actions: [acceptAction, declineAction],
                               intentIdentifiers: [],
                               hiddenPreviewsBodyPlaceholder: "",
                               options: .customDismissAction)
        
        let videoPlayerCategory =
        UNNotificationCategory(identifier: "VIDEO_PLAYER",
                               actions: [],
                               intentIdentifiers: [],
                               hiddenPreviewsBodyPlaceholder: "",
                               options: .customDismissAction)
        
        let newOfferCategory = UNNotificationCategory(identifier: "NEW_OFFER", actions: [book], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([meetingInviteCategory,newOfferCategory,videoPlayerCategory])
    }
}
