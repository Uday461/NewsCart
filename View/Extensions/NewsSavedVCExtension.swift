//
//  NewsSavedVC.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 30/07/23.
//

import Foundation
import UIKit
import MoEngageInApps
//import FileManagementSDK

//MARK: - UITableViewDataSource Methods

extension NewsSavedVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.articleDataCell) as! CustomSavedNewsCell
        cell.titleLabel.text = articleArray[indexPath.row].newsTitle
        cell.descriptionLabel.text = articleArray[indexPath.row].newsDescritption
        if let source = articleArray[indexPath.row].sourceName{
            cell.sourceLabel.text = source
        } else {
            cell.sourceLabel.text = "No source."
        }
            if let imageName = self.articleArray[indexPath.row].imageName {
                if let uiImage = fileSystemManager.retrieveImage(forImageName: imageName) {
                    cell.newsImage.image = uiImage
                } else {
                    cell.newsImage.image = UIImage(named: "no-image-icon")
                }
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let _imageName = self.articleArray[indexPath.row].imageName{
                self.fileSystemManager.deleteImage(forImageName: _imageName)
            }
            self.coreDataManager.deleteArticle(articleInfo: self.articleArray[indexPath.row])
            articleArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if (articleArray.count == 0) {
                tableView.isHidden = true
            }
        }
    }
    
}

//MARK: - MoEngageInAppNativeDelegate callback methods

extension NewsSavedVC: MoEngageInAppNativeDelegate{
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
