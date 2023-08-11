//
//  ImageExtension.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 10/08/23.
//

import Foundation
import UIKit
import ImageIO

//struct ImageHeaderData{
//    static var PNG: [UInt8] = [0x89]
//    static var JPEG: [UInt8] = [0xFF]
//    static var GIF: [UInt8] = [0x47]
//    static var TIFF_01: [UInt8] = [0x49]
//    static var TIFF_02: [UInt8] = [0x4D]
//    static var WEBP: [UInt8] = [0x57, 0x45, 0x42, 0x50]
//}
//
//enum ImageFormat{
//    case Unknown, PNG, JPEG, GIF, TIFF, WEBP
//}
//
//
//extension NSData{
//    var imageFormat: ImageFormat{
//        var buffer = [UInt8](repeating: 0, count: 1)
//        self.getBytes(&buffer, range: NSRange(location: 0,length: 1))
//        if buffer == ImageHeaderData.PNG
//        {
//            return .PNG
//        } else if buffer == ImageHeaderData.JPEG
//        {
//            return .JPEG
//        } else if buffer == ImageHeaderData.GIF
//        {
//            return .GIF
//        } else if buffer == ImageHeaderData.TIFF_01 || buffer == ImageHeaderData.TIFF_02{
//            return .TIFF
//        } else if buffer == ImageHeaderData.WEBP {
//            return .WEBP
//        }
//        else{
//            return .Unknown
//        }
//    }
//}


enum ImageFormat {
    case gif, jpg, png, webp, unknown
}
extension String {
    func contains(_ string: String) -> Bool {
        return range(of: string, options: [.literal, .caseInsensitive, .diacriticInsensitive]) != nil
    }
    
    // Checks if every element in `strings` is contained.
    func contains(_ strings: [String]) -> Bool {
        guard strings.count > 0 else {
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



