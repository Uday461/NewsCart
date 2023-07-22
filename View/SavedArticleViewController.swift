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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var articleArray = [ArticleInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadArticles()
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
            self.context.delete(self.articleArray[self.indexPathRow])
            self.articleArray.remove(at: self.indexPathRow)
            do{
                try self.context.save()
            }catch{
                print("Error saving data into context: \(error)")
            }
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default){ cancelAction in
            return
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert,animated: true, completion: nil)
    }
    
    func loadArticles(){
        let request: NSFetchRequest<ArticleInfo> = ArticleInfo.fetchRequest()
        do{
            articleArray = try context.fetch(request)
        }catch{
           print("Error in retrieving data from CoreData: \(error)")
        }
    }
    
}

