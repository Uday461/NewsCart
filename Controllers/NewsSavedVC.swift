//
//  NewsSavedVC.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 18/07/23.
//

import UIKit
import CoreData

class NewsSavedVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var articleArray = [ArticleInfo]()
    let coreDataManager = CoreDataManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 180
        tableView.register(UINib(nibName: "NoSavedArticleCell", bundle: nil), forCellReuseIdentifier: "NoSavedArticleCell")
        articleArray = coreDataManager.loadArticles()
        // loadArticles()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        // loadArticles()
        articleArray = coreDataManager.loadArticles()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}



