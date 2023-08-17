//
//  ImageExtension.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 10/08/23.
//

import Foundation
import UIKit
import ImageIO

//Following methods used for recognizing image type (".jpg",".png") 
enum ImageFormat {
    case gif, jpg, png, webp, unknown
}
extension String {
    //This method is used for checking if the substring is present in a given string with the following conditions.
    func contains(_ string: String) -> Bool {
        return range(of: string, options: [.literal, .caseInsensitive, .diacriticInsensitive]) != nil
    }
    
    //This method is used for checking if the array of substrings is present in a given string.
    func contains(_ strings: [String]) -> Bool {
        guard strings.count > 0 else {
            LogManager.e("String is empty.")
            return false
        }
        var allContained = true
        for string in strings {
            allContained = allContained && contains(string)
        }
        return allContained
    }
}

extension Data {
    func format() -> ImageFormat {
        if let string = String(data: self, encoding: .isoLatin1) {
            let prefix = String(string.prefix(30))
            if prefix.contains("ÿØÿÛ") || prefix.contains(["ÿØÿà", "JFIF"]) || prefix.contains(["ÿØÿá", "Exif"]) {
                return .jpg
            } else if prefix.contains("PNG") {
                return .png
            } else if prefix.contains("GIF87a") || prefix.contains("GIF89a"){
                return .gif
            } else if prefix.contains(["RIFF", "WEBP"]) {
                return .webp
            } else {
                print ("prefix \(prefix) is unknown")
                return .unknown
            }
        }
        return .unknown
    }
}



