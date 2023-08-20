//
//  APINewsManager.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 15/07/23.
//

import Foundation

class APINewsManager{
    var fetchNewsDelegate: FetchNews?
    //Method for URL session GET request.
    func apiRequest(urlToImage: String, key:String="" , _ completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?, _ key: String) -> Void){
        let url = URL(string: urlToImage)
        if let _url = url{
            let task = URLSession.shared.dataTask(with: _url) { data, response, error in
                completion(data, response, error, key)
            }
            task.resume()
        }
    }

    //Method for decoding the data from json object.
    func parseJSON(data: Data){
        let jsonDecode = JSONDecoder()
        var articleNewsModel: APINewsModel
        do{
            let decodedData = try jsonDecode.decode(APINewsModel.self, from: data)
            articleNewsModel = decodedData
            fetchNewsDelegate?.fetchAndUpdateNews(articleNewsModel)
        }catch{
            LogManager.log(error, logType:  .error)
        }
    }
    
    //Method for checking whether news article's title, description, url contains nil.
    func validArticlesList(articles: [Article])->[Article]?{
        var validArticles: [Article]?
        for index in 0..<articles.count{
            if let _title = articles[index].title, let _description = articles[index].description, let _url = articles[index].url{
                if (validArticles?.append(articles[index]) == nil){
                    validArticles = [articles[index]]
                }
            } else {
                LogManager.log("Invalid Article: News Article's title/description/url contains nil.", logType: .info)
            }
        }
        return validArticles
    }
    
    //Method for returning query parameter of respective selected category news.
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











