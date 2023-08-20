//
//  DownloadVideoManager.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 09/08/23.
//

import Foundation
class DownloadVideoManager{
    //URLSession Request for downloading the video.
    func downloadVideo(urlString: String,_ completion: @escaping (_ success: Bool, _ url: URL?) -> Void){
        let url = URL(string: urlString)
        if let _url = url{
            let task = URLSession.shared.downloadTask(with: _url){ (tempLocation, response, error) in
                if error == nil {
                    completion(true, tempLocation)
                } else {
                    completion(false, nil)
                }
            }
            task.resume()
        }
    }
}
