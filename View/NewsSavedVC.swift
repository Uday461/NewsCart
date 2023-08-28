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
    var articleArray = [ArticleInfo]()
    let coreDataManager = CoreDataManager()
    let fileSystemManager = FileSystemManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 180
        articleArray = coreDataManager.loadArticles()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        articleArray = coreDataManager.loadArticles()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}



