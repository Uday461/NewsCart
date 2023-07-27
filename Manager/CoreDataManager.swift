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
    
}
