//
//  StringUtils.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 14/10/23.
//

import Foundation
import UIKit
class StringUtils {
    static func returnNSAttributedString(widgetContent: String)->NSAttributedString? {
        if let htmlData = widgetContent.data(using: .utf16) {
            do {
                let attributedString = try NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                return attributedString
            } catch {
                print("Error converting HTML string: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    static func returnNSMutableAttributedStringForButton(buttonName: NSAttributedString)->NSMutableAttributedString? {
        var fontColor: UIColor?
        var range = NSRange(location: 0, length: buttonName.length)
        if let color = buttonName.attribute(.foregroundColor, at: 0, effectiveRange: &range) as? UIColor {
            fontColor = color
        }
        
        if (buttonName.length > 17) {
            let attributedString1 = buttonName.attributedSubstring(from: NSRange(location: 0, length: 17))
            var attributedNewString: NSAttributedString = NSAttributedString(string: "")
            let attributedString2 = NSAttributedString(string: "...")
            attributedNewString = NSAttributedString(string: attributedString2.string, attributes: [.foregroundColor: fontColor!])
            let mutableAttributedString = NSMutableAttributedString(string: attributedString1.string, attributes:[.font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: fontColor!])
            mutableAttributedString.append(attributedNewString)
            return mutableAttributedString
        } else {
            let mutableAttributedString = NSMutableAttributedString(string: buttonName.string, attributes:[.font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: fontColor!])
            return mutableAttributedString
        }
        return nil
    }
}
