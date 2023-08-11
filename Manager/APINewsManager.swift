//
//  APINewsManager.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 15/07/23.
//

import Foundation
import UIKit

class APINewsManager{
    var fetchNewsDelegate: FetchNews?
    
    //Method for decoding the fetched data from news API.
    func apiRequest(urlToImage: String, count:Int=0 , _ completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?, _ count: Int) -> Void){
        let url = URL(string: urlToImage)
        if let _url = url{
            let task = URLSession.shared.dataTask(with: _url) { data, response, error in
                completion(data, response, error, count)
            }
            task.resume()
        }
    }

    
    func parseJSON(data: Data){
        let jsonDecode = JSONDecoder()
        var articleNewsModel: APINewsModel
        do{
            let decodedData = try jsonDecode.decode(APINewsModel.self, from: data)
            print(decodedData)
            articleNewsModel = decodedData
            fetchNewsDelegate?.fetchAndUpdateNews(articleNewsModel)
        }catch{
            print("Error: \(error)")
            DispatchQueue.main.async {
                self.fetchNewsDelegate?.didFailErrorDueToDecoding(error)
            }
        }
    }
    
    func validArticlesList(articles: [Article])->[Article]?{
        var validArticles: [Article]?
        for index in 0..<articles.count{
            if let _title = articles[index].title, let _description = articles[index].description, let _url = articles[index].url{
                if (validArticles?.append(articles[index]) == nil){
                    validArticles = [articles[index]]
                }
            }
        }
        return validArticles
    }
    
    func categoryConstants(category: String) -> String?{
        let returnCategory: String?
        switch category{
        case "Business": returnCategory = Constants.businessNewsApiQuery
        case "Health": returnCategory = Constants.healthNewsApiQuery
        case "Technology": returnCategory = Constants.technologyNewsApiQuery
        case "Science": returnCategory = Constants.scienceNewsApiQuery
        case "Sports": returnCategory = Constants.sportsNewsApiQuery
        default: returnCategory = nil
        }
        return returnCategory
    }
  
}











