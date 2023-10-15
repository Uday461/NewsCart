//
//  ReturnAPINewsModel.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 11/09/23.
//

import Foundation
class ReturnAPINewsModel{
    var apiNewsManager = APINewsManager()
    var fetchNewsDelegate: FetchNews?
    var articleNewsModel: APINewsModel?

    func fetchNews(newsUrl: String){
        apiNewsManager.apiRequest(url: newsUrl) { data, response, error, key in
            if let _data = data{
                self.parseJSON(data: _data)
            } else if let _error = error{
                DispatchQueue.main.async {
                    self.fetchNewsDelegate?.didFailErrorDueToNetwork(_error)
                }
            }
        }
    }
    
    func parseJSON(data: Data){
        let jsonDecode = JSONDecoder()
        do{
            let decodedData = try jsonDecode.decode(APINewsModel.self, from: data)
            articleNewsModel = decodedData
            if let articleNewsModel = articleNewsModel{
                fetchNewsDelegate?.fetchAndUpdateNews(articleNewsModel)
            }
        }catch{
            LogManager.error(error.localizedDescription)
        }
    }
}
