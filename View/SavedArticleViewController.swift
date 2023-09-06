//
//  SavedArticleViewController.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 19/07/23.
//

import UIKit
import CoreData
import MoEngageInApps
import FileManagementSDK

class SavedArticleViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var indexPathRow: Int!
    let coreDataManager = CoreDataManager()
    var articleArray = [ArticleInfo]()
    let fileSystemManager = FileSystemManager()
    var campaign_text: String = ""
    var campaignInfo: MoEngageInAppSelfHandledCampaign? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        articleArray = coreDataManager.loadArticles()
        DispatchQueue.main.async {
            let title = self.articleArray[self.indexPathRow].newsTitle
            self.titleLabel.text = title
            let description = self.articleArray[self.indexPathRow].newsDescritption
            self.descriptionLabel.text = description
            if let _imageName = self.articleArray[self.indexPathRow].imageName {
                self.imageView.image = self.fileSystemManager.retrieveImage(forImageName: _imageName)
            }
        }
        MoEngageSDKInApp.sharedInstance.setInAppDelegate(self)
        MoEngageSDKInApp.sharedInstance.showInApp()
        selfHandledInApps()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Are you sure, you want to delete.", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive){ okAction in
            if let _imageName = self.articleArray[self.indexPathRow].imageName{
                self.fileSystemManager.deleteImage(forImageName: _imageName)
            }
            self.coreDataManager.deleteArticle(articleInfo: self.articleArray[self.indexPathRow])
            self.articleArray.remove(at: self.indexPathRow)
            LogManager.logging("News article is deleted.")
            if self.articleArray.count != 0{
                self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
                DispatchQueue.main.async {
                    let alert = AlertsManager.emptyBookMarkedItemsAlert()
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default){ cancelAction in
            return
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert,animated: true, completion: nil)
    }
    
    func selfHandledInApps(){
        MoEngageSDKInApp.sharedInstance.getSelfHandledInApp { campaignInfo, accountMeta in
            if let campaignInfo = campaignInfo{
                LogManager.logging("Self-Hanled InApp Content \(campaignInfo.campaignContent)")
                self.campaign_text = campaignInfo.campaignContent
                self.campaignInfo = campaignInfo
                self.performSegue(withIdentifier: "goToInApp", sender: self)
                // Update UI with Self Handled InApp Content
            } else{
                LogManager.logging("No Self Handled campaign available")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let inAppViewController = segue.destination as! InAppViewController
         inAppViewController.inAppText = campaign_text
         inAppViewController.campaignInfo = campaignInfo
     }
}


extension SavedArticleViewController: MoEngageInAppNativeDelegate{
    // Called when an inApp is shown on the screen
    func inAppShown(withCampaignInfo inappCampaign: MoEngageInApps.MoEngageInAppCampaign, forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
        LogManager.logging("InApp shown callback for Campaign ID(\(inappCampaign.campaignId)) and CampaignName(\(inappCampaign.campaignName))")
        LogManager.logging("Account Meta AppID: \(accountMeta.appID)")
    }
    
    // Called when an inApp is clicked by the user, and it has been configured with a navigation action
    func inAppClicked(withCampaignInfo inappCampaign: MoEngageInApps.MoEngageInAppCampaign, andNavigationActionInfo navigationAction: MoEngageInApps.MoEngageInAppAction, forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
        LogManager.logging("InApp Clicked with Campaign ID \(inappCampaign.campaignId)")
        LogManager.logging("Navigation Action Screen Name \(navigationAction.screenName ?? "Screen Unknown") Key Value Pairs: \((navigationAction.keyValuePairs))")
    }
    
    // Called when an inApp is clicked by the user, and it has been configured with a custom action
    func inAppClicked(withCampaignInfo inappCampaign: MoEngageInApps.MoEngageInAppCampaign, andCustomActionInfo customAction: MoEngageInApps.MoEngageInAppAction, forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
        LogManager.logging("InApp Clicked with Campaign ID \(inappCampaign.campaignId)")
        LogManager.logging("Custom Actions Key Value Pairs: \(customAction.keyValuePairs)")
    }
    
    // Called when an inApp is dismissed by the user
    func inAppDismissed(withCampaignInfo inappCampaign: MoEngageInApps.MoEngageInAppCampaign, forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
        LogManager.logging("InApp dismissed callback for Campaign ID(\(inappCampaign.campaignId)) and CampaignName(\(inappCampaign.campaignName))")
        LogManager.logging("Account Meta AppID: \(accountMeta.appID)")
    }
    

    func selfHandledInAppTriggered(withInfo inappCampaign: MoEngageInApps.MoEngageInAppSelfHandledCampaign, forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
        print("InApp Campaign Creation: \(inappCampaign.campaignContent)")
    }
}
