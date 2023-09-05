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
import FileManagementSDK

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
        apiNewsManager.fetchNews(newsUrl: "\(APIEndPoints.apiForFetchingNews)\(page)")
        MoEngageSDKInbox.sharedInstance.getInboxViewController(withUIConfiguration: MoEngageInboxConfiguration.getMoEngageInboxConfiguration(), withInboxWithControllerDelegate: self, forAppID: Constants.appID) { inboxController in
            self.inboxController = inboxController
        }
        
        MoEngageSDKAnalytics.sharedInstance.setUniqueID("NewsCart123")
        MoEngageSDKAnalytics.sharedInstance.setName("Uday Kiran")
        MoEngageSDKAnalytics.sharedInstance.setEmailID("uday123@gmail")
        MoEngageSDKAnalytics.sharedInstance.trackEvent("NewsCartEvent")
        
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
    
    //Called when inbox cell is selected
    func inboxEntryClicked(_ inboxItem: MoEngageInboxEntry) {
        LogManager.logging("Inbox item clicked")
        LogManager.logging("Is Read: \(inboxItem.isRead)")
        if !inboxItem.isRead {
            MoEngageSDKInbox.sharedInstance.markInboxNotificationClicked(withCampaignID: inboxItem.campaignID!)
         //   MoEngageSDKInbox.sharedInstance.processInboxNotification(withCampaignID: inboxItem.campaignID!)
        }
     //   MoEngageSDKInbox.sharedInstance.trackInboxClick(withCampaignID: inboxItem.campaignID!)
        MoEngageSDKInbox.sharedInstance.getInboxMessages(forAppID:Constants.appID) { inboxMessages, account in
             print("Received Inbox messages")
             print(inboxMessages)
         }
       
    }
    
    //Called when inbox item is deleted
    func inboxEntryDeleted(_ inboxItem: MoEngageInboxEntry) {
        LogManager.logging("Inbox item deleted")
    }
    
    // Called when MoEngageInboxViewController is dismissed after being presented
    func inboxViewControllerDismissed() {
        LogManager.logging("Dismissed")
    }
    
}

