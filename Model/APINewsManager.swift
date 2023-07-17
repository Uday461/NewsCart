//
//  APINewsManager.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 15/07/23.
//

import Foundation
import UIKit

struct APINewsManager{
    var fetchNewsDelegate: fetchNews?
    func performRequestForNews(urlString: String){
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!){Data, Response, Error in
            if let error = Error{
                DispatchQueue.main.async {
                    fetchNewsDelegate?.didFailError(error: error)
                }
                return
            } else if let data = Data{
                parseJSON(data: data)
            }
        }
        task.resume()
    }
    
    func parseJSON(data: Data){
        let jsonDecode = JSONDecoder()
        var articlesArray: [ArticleData] = []
        var article: ArticleData = ArticleData()
        do{
            let decodedData = try jsonDecode.decode(APINewsModel.self, from: data)
            let articles = decodedData.articles
            print("total Number of Articles:\(articles.count)")
            for index in 0..<(articles.count) {
                article.sourceName = articles[index].source.name ?? nil
                article.description = articles[index].description ?? nil
                article.title = articles[index].title ?? nil
                article.url = articles[index].url ?? nil
                article.urlToImage = articles[index].urlToImage ?? nil
                articlesArray.append(article)
            }
            downloadPhoto(articleArray: articlesArray)
            fetchNewsDelegate?.fetchAndUpdateNews(articlesArray)
        }catch{
            DispatchQueue.main.async {
                fetchNewsDelegate?.didFailError(error: error)
            }
        }
    }
    
    func downloadPhoto(articleArray: [ArticleData]){
        var newsImageArray: [UIImage] = []
        newsImageArray.removeAll() // this is the image array
        for i in 0..<articleArray.count {
            if let urlToImage = articleArray[i].urlToImage{
                guard let url = URL(string: urlToImage) else {
                    DispatchQueue.main.async {
                        newsImageArray.append(UIImage(named: "no-image-icon")!)
                    }
                    continue
                }
                let group = DispatchGroup()
                group.enter()
                URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                    if let imgData = data, let image = UIImage(data: imgData) {
                        DispatchQueue.main.async() {
                            newsImageArray.append(image)
                        }
                    } else if let error = error {
                        DispatchQueue.main.async {
                            fetchNewsDelegate?.didFailError(error: error)
                        }
                        return
                    }
                    group.leave()
                }).resume()
                group.wait()
            } else {
                DispatchQueue.main.async {
                    newsImageArray.append(UIImage(named: "no-image-icon")!)
                }
            }
            
        }
        fetchNewsDelegate?.fetchImagesToNews(newsImageArray)
    }
    
    
    
}
