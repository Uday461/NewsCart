//
//  CoreDataManager.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 26/07/23.
//

import Foundation
import UIKit
import CoreData
class CoreDataManager{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var articleArray = [ArticleInfo]()
    func fetchSavedArticle(urlLink: String) -> [ArticleInfo]{
        var fetchSavedArticle = [ArticleInfo]()
        let request: NSFetchRequest<ArticleInfo> = ArticleInfo.fetchRequest()
        let predicate = NSPredicate(format: "urlLink MATCHES[cd] %@", urlLink)
        request.predicate = predicate
        do{
            fetchSavedArticle = try context.fetch(request)
        } catch {
            print("Error fetching saved article: \(error)")
        }
        return fetchSavedArticle
    }
    
    func loadArticles()->[ArticleInfo]{
        let request: NSFetchRequest<ArticleInfo> = ArticleInfo.fetchRequest()
        do{
            articleArray = try context.fetch(request)
        }catch{
            print("Error in retrieving data from CoreData: \(error)")
        }
        return articleArray
    }
    
    func deleteArticle(articleInfo: ArticleInfo){
        self.context.delete(articleInfo)
        do{
            try self.context.save()
        }catch{
            print("Error saving data into context: \(error)")
        }
    }
    
    func saveArticle(){
        do{
            try context.save()
        }catch{
            print("Error saving data into context: \(error)")
        }
    }
}
