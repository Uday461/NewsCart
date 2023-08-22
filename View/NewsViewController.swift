//
//  ViewController.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 14/07/23.
//

import UIKit
import SafariServices
import CoreData
import OSLog

class NewsViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var apiNewsModel: APINewsModel?
    var articles: [Article]?
    var page = 1
    let apiNewsManager = APINewsManager()
    let fileSystemManager = FileSystemManager()
    var header = HeaderView(frame: .zero)
    var invalidArticlesCount = 0
    let coreDataManager = CoreDataManager()
    var fetchSavedArticle = [ArticleInfo]()
    var imagesDictionary: [String:ImagePropertyModel] = [:]
    var totalArticles = 0
    var _data: Data? = nil
    let context = CoreDataConfiguration.shared.persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        header.fetchCategoryNewsDelegate = self
        apiNewsManager.fetchNewsDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupTableHeaderView()
        header.setupPopButton()
        apiNewsManager.fetchNews(newsUrl: "\(APIEndPoints.apiForFetchingNews)\(page)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
}

