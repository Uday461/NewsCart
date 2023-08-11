//
//  FileSystemManager.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 10/08/23.
//

import Foundation
import UIKit

class FileSystemManager{
    func filePath(forKey key: Int, imageFormat format: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(String(key) + format)
    }
    
    func store(image: UIImage, forKey key: Int, imageFormat format: String) {
        if (format == ".png"){
            if let pngRepresentation = image.pngData() {
                if let filePath = filePath(forKey: key, imageFormat: format) {
                    print(filePath)
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            }
        } else if (format == ".jpg"){
            if let jpgRepresentation = image.jpegData(compressionQuality: 1){
                if let filePath = filePath(forKey: key, imageFormat: format) {
                    print(filePath)
                    do  {
                        try jpgRepresentation.write(to: filePath)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            }
        }
    }
    
    func retrieveImage(forKey key: Int, imageFormat format: String) -> UIImage? {
        if let filePath = self.filePath(forKey: key, imageFormat: format),
           let fileData = FileManager.default.contents(atPath: filePath.path),
           let image = UIImage(data: fileData) {
            return image
        }
        return nil
    }
}
