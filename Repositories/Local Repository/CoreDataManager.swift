//
//  CoreDataManager.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 26/07/23.
//

import Foundation
import CoreData

class CoreDataManager{
    let context = CoreDataConfiguration.shared.persistentContainer.viewContext
    var articleArray = [ArticleInfo]()
    func fetchSavedArticle(urlLink: String) -> [ArticleInfo]{
        var fetchSavedArticle = [ArticleInfo]()
        let request: NSFetchRequest<ArticleInfo> = ArticleInfo.fetchRequest()
        let predicate = NSPredicate(format: "urlLink == %@", urlLink)
        request.predicate = predicate
        do{
            fetchSavedArticle = try context.fetch(request)
        } catch {
            LogManager.error("Error in fetching Saved Articles in CoreData: \(error.localizedDescription)")
        }
        return fetchSavedArticle
    }
    
    func loadArticles()->[ArticleInfo]{
        let request: NSFetchRequest<ArticleInfo> = ArticleInfo.fetchRequest()
        do{
            articleArray = try context.fetch(request)
        }catch{
            LogManager.error("Error in retrieving data from CoreData: \(error.localizedDescription)")
        }
        return articleArray
    }
    
    func deleteArticle(articleInfo: ArticleInfo){
        self.context.delete(articleInfo)
        do{
            try self.context.save()
        }catch{
            LogManager.error("Error saving data into context:\(error.localizedDescription)")
        }
    }
    
    func saveArticle(){
        do{
            try context.save()
        }catch{
            LogManager.error("Error saving data into context:\(error.localizedDescription)")
        }
    }
 
    func articleInfoModel(imageName: String, newsDescription: String, newsTitle: String, sourceName: String?, urlLink: String)->ArticleInfo{
        let newArticle = ArticleInfo(context: context)
        newArticle.imageName = imageName
        newArticle.newsDescritption = newsDescription
        newArticle.newsTitle = newsTitle
        newArticle.sourceName = sourceName
        newArticle.urlLink = urlLink
        return newArticle
    }
}
