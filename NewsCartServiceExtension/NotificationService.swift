//
//  NotificationService.swift
//  NewsCartServiceExtension
//
//  Created by UdayKiran Naik on 02/08/23.
//

import UserNotifications
import Foundation
import UIKit
class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        defer {
            contentHandler(bestAttemptContent ?? request.content)
            }
            
            guard let attachment = request.attachment else { return }
           bestAttemptContent?.attachments = [attachment]
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}

extension UNNotificationRequest {
    var attachment: UNNotificationAttachment? {
        guard let attachmentURL = content.userInfo["media_url"] as? String, let data = try? Data(contentsOf: URL(string: attachmentURL)!), let mediaType = content.userInfo["media_type"] else {
            return nil
        }
        let mediaTypeString = mediaType as? String
        var videoData: Data? = nil
        if (mediaTypeString == "VIDEO"){
            let downloadVideoManager = DownloadVideoManager()
            downloadVideoManager.downloadVideo(urlString: attachmentURL) { success, url in
                if (success){
                    if let _url = url {
                        videoData = try? Data(contentsOf: _url)
                    }
                }
            }
            if let _videoData = videoData{
        return try? UNNotificationAttachment(data: _videoData, mediaType: mediaType, options: nil)

            }
        }
        return try? UNNotificationAttachment(data: data, mediaType: mediaType, options: nil)
    }
}

extension UNNotificationAttachment {
    convenience init(data: Data, mediaType: Any, options: [NSObject: AnyObject]?) throws {
        let fileManager = FileManager.default
        let temporaryFolderName = ProcessInfo.processInfo.globallyUniqueString
        let temporaryFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(temporaryFolderName, isDirectory: true)
        
        try fileManager.createDirectory(at: temporaryFolderURL, withIntermediateDirectories: true, attributes: nil)
        var mediaFileIdentifier: String = ""
        let mediaTypeInString = mediaType as? String
        if mediaTypeInString == "GIF"{
            mediaFileIdentifier = UUID().uuidString + ".gif"
        } else if mediaTypeInString == "IMAGE"{
            mediaFileIdentifier = UUID().uuidString + ".jpg"
        } else if mediaTypeInString == "VIDEO"{
            mediaFileIdentifier = UUID().uuidString + ".mp4"
        }
        let fileURL = temporaryFolderURL.appendingPathComponent(mediaFileIdentifier)
        try data.write(to: fileURL)
        try self.init(identifier: mediaFileIdentifier, url: fileURL, options: options)
    }
}
