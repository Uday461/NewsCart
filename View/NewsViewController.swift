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
import MoEngageSDK
import MoEngageInbox
import CoreLocation
import MoEngageCards
import MoEngageInApps

class NewsViewController: UIViewController, MoEngageInboxViewControllerDelegate, MoEngageCardsDelegate{
    
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
    var moEngageCardsCampaignArray = [MoEngageCardCampaign]()
    var totalArticles = 0
    var _data: Data? = nil
    let context = CoreDataConfiguration.shared.persistentContainer.viewContext
    var inboxController: MoEngageInboxViewController?
    var isLoading = false
    var isPaginationComplete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        header.fetchCategoryNewsDelegate = self
        header.fetchInboxMessagesDelegate = self
        header.fetchCardsInboxMessagesDelegate = self
        header.fetchSelfHandledCardsInbox = self
        apiNewsManager.fetchNewsDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupTableHeaderView()
        header.setupPopButton()
      //  createSpinnerView()
        let tableViewLoadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: "loadingcellid")
        
        apiNewsManager.fetchNews(newsUrl: "\(APIEndPoints.apiForFetchingNews)\(page)")
        MoEngageSDKInbox.sharedInstance.getInboxViewController(withUIConfiguration: MoEngageInboxConfiguration.getMoEngageInboxConfiguration(), withInboxWithControllerDelegate: self, forAppID: Constants.appID) { inboxController in
            self.inboxController = inboxController
        }
        
        MoEngageSDKAnalytics.sharedInstance.setUniqueID("NewsCart123")
        MoEngageSDKAnalytics.sharedInstance.setName("Uday Kiran")
        MoEngageSDKAnalytics.sharedInstance.setEmailID("uday123@gmail")
        
        let manager = CLLocationManager()
        LogManager.logging("Location Status: \(manager.authorizationStatus)")
        RequestLocationAuthorization.locationManagerDidChangeAuthorization(manager)
        LogManager.logging("Location Status: \(manager.authorizationStatus)")
        MoEngageSDKCards.sharedInstance.setCardsDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        MoEngageSDKCards.sharedInstance.getCardsData { cardsData, accountMeta in
            LogManager.logging("Cards category \(String(describing: cardsData?.cardCategories))")
            LogManager.logging("Cards Data \(String(describing: cardsData?.cards))")
            if let _cards = cardsData?.cards{
                self.moEngageCardsCampaignArray = _cards
            }
        }
        
    }
    
    func loadMoreData() {
            if !self.isLoading {
                self.isLoading = true
                DispatchQueue.global().asyncAfter(deadline: .now()) {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.isLoading = false
                    }
                }
            }
    }
}
