//
//  NewsSavedVC.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 18/07/23.
//

import UIKit
import CoreData
import MoEngageInApps
import FileManagementSDK

class NewsSavedVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var articleArray = [ArticleInfo]()
    let coreDataManager = CoreDataManager()
    let fileSystemManager = FileSystemManager()
    let fileManager = FileManager.default
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 180
        articleArray = coreDataManager.loadArticles()
        MoEngageSDKInApp.sharedInstance.setInAppDelegate(self)
        MoEngageSDKInApp.sharedInstance.showInApp()
        MoEngageSDKInApp.sharedInstance.showNudge(atPosition: NudgePositionTop)
        MoEngageSDKInApp.sharedInstance.setCurrentInAppContexts(["Offer"])
    //    selfHandledInApps()
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
    
//    func selfHandledInApps(){
//        MoEngageSDKInApp.sharedInstance.getSelfHandledInApp { campaignInfo, accountMeta in
//            if let campaignInfo = campaignInfo{
//                LogManager.logging("Self-Hanled InApp Content \(campaignInfo.campaignContent)")
//                MoEngageSDKInApp.sharedInstance.selfHandledShown(campaignInfo: campaignInfo)
//                // Update UI with Self Handled InApp Content
//            } else{
//                LogManager.logging("No Self Handled campaign available")
//            }
//        }
//    }
}



