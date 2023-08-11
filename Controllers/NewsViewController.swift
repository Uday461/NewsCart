//
//  ViewController.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 14/07/23.
//

import UIKit
import SafariServices
import CoreData

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
   // var imagesDictionary: [String:UIImage] = [:]
    var imagesDictionary:[String:ImageProperty] = [:]
    var imageCount = 0
    var _data: Data? = nil
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
        apiNewsManager.apiRequest(urlToImage: "\(Constants.apiForFetchingNews)\(page)") { data, response, error, count in
            if let _data = data{
                self.apiNewsManager.parseJSON(data: _data)
            } else if let _error = error{
                DispatchQueue.main.async {
                    self.didFailErrorDueToNetwork(_error)
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(#function)
        tableView.reloadData()
    }
    
}

