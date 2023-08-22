//
//  SavedArticleViewController.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 19/07/23.
//

import UIKit
import CoreData

class SavedArticleViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var indexPathRow: Int!
    let coreDataManager = CoreDataManager()
    var articleArray = [ArticleInfo]()
    let fileSystemManager = FileSystemManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleArray = coreDataManager.loadArticles()
        DispatchQueue.main.async {
            let title = self.articleArray[self.indexPathRow].newsTitle
            self.titleLabel.text = title
            let description = self.articleArray[self.indexPathRow].newsDescritption
            self.descriptionLabel.text = description
            if let _imageName = self.articleArray[self.indexPathRow].imageName {
                self.imageView.image = self.fileSystemManager.retrieveImage(forImageName: _imageName)
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure, you want to delete.", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive){ okAction in
            if let _imageName = self.articleArray[self.indexPathRow].imageName{
                self.fileSystemManager.deleteImage(forImageName: _imageName)
            }
            self.coreDataManager.deleteArticle(articleInfo: self.articleArray[self.indexPathRow])
            self.articleArray.remove(at: self.indexPathRow)
            LogManager.log("News article is deleted.", logType: .info)
            if self.articleArray.count != 0{
                self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
                DispatchQueue.main.async {
                    let alert = AlertsManager.emptyBookMarkedItemsAlert()
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default){ cancelAction in
            return
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert,animated: true, completion: nil)
    }
    
}

