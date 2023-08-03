//
//  ViewController.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 14/07/23.
//

import UIKit
import SafariServices
import CoreData

class NewsAPIViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var apiNewsModel: APINewsModel?
    var articles: [Article]?
    var page = 1
    let apiNewsManager = APINewsManager()
    var header = HeaderView(frame: .zero)
    var invalidArticlesCount = 0
    let coreDataManager = CoreDataManager()
    var fetchSavedArticle = [ArticleInfo]()
    var imagesDictionary: [String:UIImage] = [:]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        // Do any additional setup after loading the view.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        header.fetchCategoryNewsDelegate = self
        apiNewsManager.fetchNewsDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupTableHeaderView()
        header.setupPopButton()
        apiNewsManager.fetchNews(urlString: Constants.apiForFetchingNews,page: page, pageSize: Constants.pageSize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(#function)
        tableView.reloadData()
    }
    
}

