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
    
    //Method for fetching News from API
    func fetchNews(urlString: String, page:Int, pageSize: Int){
        let url = URL(string: "\(urlString)&page=\(page)&pageSize=\(pageSize)")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!){Data, Response, Error in
            if let error = Error{
                DispatchQueue.main.async {
                    self.fetchNewsDelegate?.didFailErrorDueToNetwork(error)
                }
                return
            } else if let data = Data{
                let dataString = String(data: data, encoding: .utf8)
                print(dataString ?? "nil")
                self.parseJSON(data: data)
            }
        }
        task.resume()
    }
    
    //Method for decoding the fetched data from news API.
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
            self.fetchNewsDelegate?.didFailErrorDueToDecoding(error)
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

