//
//  NewsSavedVC.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 18/07/23.
//

import UIKit
import CoreData
import MoEngageInApps
//import FileManagementSDK

class NewsSavedVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var articleArray = [ArticleInfo]()
    let coreDataManager = CoreDataManager()
    let fileSystemManager = FileSystemManager()
    let fileManager = FileManager.default
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = 180
        articleArray = coreDataManager.loadArticles()
        MoEngageSDKInApp.sharedInstance.setInAppDelegate(self)
        MoEngageSDKInApp.sharedInstance.showInApp()
        MoEngageSDKInApp.sharedInstance.showNudge(atPosition: NudgePositionTop)
        MoEngageSDKInApp.sharedInstance.setCurrentInAppContexts(["Offer"])
        if (articleArray.count == 0) {
            tableView.isHidden = true
        }
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



