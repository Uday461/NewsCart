//
//  AlertsManager.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 18/08/23.
//

import Foundation
import UIKit
class AlertsManager{
    static func alertMessage(error: Error)->UIAlertController{
        let alert = UIAlertController(title: "Error!!.", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        return alert
    }
    static func alertMessageForNewsUpdate()->UIAlertController{
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "checkmark.circle")
        
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        
        let alert = UIAlertController(title: "", message: "You caught up all the news updates.", preferredStyle: .alert)
        alert.setValue(fullString, forKey: "attributedTitle")
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        return alert
    }
}
