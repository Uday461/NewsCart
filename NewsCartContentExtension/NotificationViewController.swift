//
//  NotificationViewController.swift
//  NewsCartContentExtension
//
//  Created by UdayKiran Naik on 03/08/23.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MoEngageRichNotification
class NotificationViewController: UIViewController, UNNotificationContentExtension {

  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        MoEngageSDKRichNotification.setAppGroupID("group.com.Uday.NewsCart.MoEngage")
    
    }
    func didReceive(_ notification: UNNotification) {
//        let content = notification.request.content
//        titleLabel.text = content.title
//        bodyLabel.text = content.body
    MoEngageSDKRichNotification.addPushTemplate(toController: self, withNotification: notification)
    }

}
