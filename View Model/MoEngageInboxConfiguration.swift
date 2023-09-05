//
//  MoEngageInboxConfiguration.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 27/08/23.
//

import Foundation
import MoEngageInbox
import UIKit
class MoEngageInboxConfiguration{
    class func getMoEngageInboxConfiguration() -> MoEngageInboxUIConfiguration{
        let configuration  = MoEngageInboxUIConfiguration()
        configuration.cellUnreadBackgroundColor = UIColor(named: "unreadColor")!
        configuration.cellSelectionTintColor = .darkGray
        return configuration
    }
}
