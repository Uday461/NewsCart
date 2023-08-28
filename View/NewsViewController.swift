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
class NewsViewController: UIViewController, MoEngageInboxViewControllerDelegate{
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
    var inboxController: MoEngageInboxViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        header.fetchCategoryNewsDelegate = self
        header.fetchInboxMessagesDelegate = self
        apiNewsManager.fetchNewsDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupTableHeaderView()
        header.setupPopButton()
        apiNewsManager.fetchNews(newsUrl: "\(APIEndPoints.apiForFetchingNews)\(page)")
        MoEngageSDKInbox.sharedInstance.getInboxViewController(withUIConfiguration: MoEngageInboxConfiguration.getMoEngageInboxConfiguration(), withInboxWithControllerDelegate: self, forAppID: "group.com.Uday.NewsCart.MoEngage") { inboxController in
            self.inboxController = inboxController
        }
        
        MoEngageSDKAnalytics.sharedInstance.setUniqueID("NewsCart123")
        MoEngageSDKAnalytics.sharedInstance.setName("Uday Kiran")
        MoEngageSDKAnalytics.sharedInstance.setEmailID("uday123@gmail")
        MoEngageSDKAnalytics.sharedInstance.trackEvent("NewsCartEvent")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    //Called when inbox cell is selected
    func inboxEntryClicked(_ inboxItem: MoEngageInboxEntry) {
        print("Inbox item clicked")
        print("Is Read: \(inboxItem.isRead)")
        if !inboxItem.isRead {
            MoEngageSDKInbox.sharedInstance.markInboxNotificationClicked(withCampaignID: inboxItem.campaignID!)
         //   MoEngageSDKInbox.sharedInstance.processInboxNotification(withCampaignID: inboxItem.campaignID!)
        }
     //   MoEngageSDKInbox.sharedInstance.trackInboxClick(withCampaignID: inboxItem.campaignID!)
        MoEngageSDKInbox.sharedInstance.getInboxMessages(forAppID:  "group.com.Uday.NewsCart.MoEngage") { inboxMessages, account in
             print("Received Inbox messages")
             print(inboxMessages)
         }
       
    }
    
    //Called when inbox item is deleted
    func inboxEntryDeleted(_ inboxItem: MoEngageInboxEntry) {
        print("Inbox item deleted")
    }
    
    // Called when MoEngageInboxViewController is dismissed after being presented
    func inboxViewControllerDismissed() {
        print("Dismissed")
    }
}

