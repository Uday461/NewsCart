//
//  NotificationViewController.swift
//  NewsCartContentExtension
//
//  Created by UdayKiran Naik on 03/08/23.
//

import UIKit
import UserNotifications
import UserNotificationsUI
class NotificationViewController: UIViewController, UNNotificationContentExtension {

  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        titleLabel.text = content.title
        bodyLabel.text = content.body

    }

}
