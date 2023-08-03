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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var articleArray = [ArticleInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // loadArticles()
        articleArray = coreDataManager.loadArticles()
        DispatchQueue.main.async {
            if let title = self.articleArray[self.indexPathRow].newsTitle{
                self.titleLabel.text = title
            } else {
                self.titleLabel.text = "No title."
            }
            if let description = self.articleArray[self.indexPathRow].newsDescritption{
                self.descriptionLabel.text = description
            } else {
                self.descriptionLabel.text = "No description."
            }
            let imageBinary = self.articleArray[self.indexPathRow].newsImage
            self.imageView.image = UIImage(data: imageBinary!)
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure, you want to delete.", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive){ okAction in
            self.coreDataManager.deleteArticle(articleInfo: self.articleArray[self.indexPathRow])
            self.articleArray.remove(at: self.indexPathRow)
            if self.articleArray.count != 0{
                self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Empty Bookmarked Items", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
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

