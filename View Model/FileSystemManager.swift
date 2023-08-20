//
//  FileSystemManager.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 10/08/23.
//

import Foundation
import CommonCrypto
import UIKit
class FileSystemManager{
    //Method for fetching the documentary URL path.
    func filePath(forImageName imageName: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first else {
            LogManager.log("Error: File doesn't exit.", logType: .error)
            return nil
        }
        return documentURL.appendingPathComponent(imageName)
    }
    //Method for storing the image into documentary.
    func store(image: UIImage, forImageName imageName: String, imageFormat format: String) {
        if (format == ".png"){
            if let pngRepresentation = image.pngData() {
                if let filePath = filePath(forImageName: imageName) {
                    LogManager.log(filePath, logType: .info)
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                    } catch let err {
                        LogManager.log("Saving file resulted in error: \(err)", logType: .error)
                    }
                }
            }
        } else if (format == ".jpg"){
            if let jpgRepresentation = image.jpegData(compressionQuality: 1){
                if let filePath = filePath(forImageName: imageName) {
                    LogManager.log(filePath, logType: .info)
                    do  {
                        try jpgRepresentation.write(to: filePath)
                    } catch let err {
                        LogManager.log("Saving file resulted in error: \(err)", logType: .error)
                    }
                }
            }
        }
    }
    //Method for generating unique file name from URLString to identify images uniquely.
    func generateUniqueFilename(forUrlString urlString: String)-> String?{
        guard let data = urlString.data(using: .utf8) else {
            return nil
        }
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = data.withUnsafeBytes{
            CC_SHA256($0.baseAddress,UInt32(data.count),&digest)
        }
        let fileName = digest.map{String(format: "%02hhx", $0)}.joined()
        return "image_"+fileName
    }
    //Method for deleting the images from documentary.
    func deleteImage(forImageName imageName: String){
        if let filePath = self.filePath(forImageName: imageName){
            print(filePath)
            do{
                try FileManager.default.removeItem(at: filePath)
            } catch{
                LogManager.log("Error in deleting file from documentry folder:\(error)", logType: .error)
            }
        }
    }
    //Method for retrieving the imageFile selected from Documentary.
    func retrieveImage(forImageName imageName: String) -> UIImage? {
        if let filePath = self.filePath(forImageName: imageName),
           let fileData = FileManager.default.contents(atPath: filePath.path),
           let image = UIImage(data: fileData) {
            return image
        }
        LogManager.log("The selected Image File doesn't exit!!.", logType: .error)
        return nil
    }
    
}
