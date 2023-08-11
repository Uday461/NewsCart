//
//  NotificationViewController.swift
//  VideoContentExtension
//
//  Created by UdayKiran Naik on 09/08/23.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import AVKit
class NotificationViewController: UIViewController, UNNotificationContentExtension {

    
    @IBOutlet weak var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        preferredContentSize.height = 300
        let content = notification.request.content
        if let aps = content.userInfo["aps"] as? [String:AnyHashable], let videoUrlString = aps["video_url"] as? String{
            if let url = URL(string: videoUrlString){
                setupVideoPlayer(url: url)
            }
        }
    }
    
    func setupVideoPlayer(url: URL){
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer()
        playerViewController.player = player
        playerViewController.view.frame = backgroundView.bounds
        self.backgroundView.addSubview(playerViewController.view)
        addChild(playerViewController)
        playerViewController.didMove(toParent: self)
        player.play()
    }

}
