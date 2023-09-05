//
//  NewsSavedVC.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 30/07/23.
//

import Foundation
import UIKit
import MoEngageInApps

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
        DispatchQueue.main.async {
            if let imageName = self.articleArray[indexPath.row].imageName {
                cell.newsImage.image = self.fileSystemManager.retrieveImage(forImageName: imageName)
            }
        }
        return cell
    }
    
}

//MARK: - UITableViewDelegate Methods

extension NewsSavedVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let count = articleArray.count
        if  (count == 0){
            return
        }
        performSegue(withIdentifier: Identifiers.goToNewsVC, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let savedArticlesVC = segue.destination as! SavedArticleViewController
        let selectedRow = tableView.indexPathForSelectedRow!.row
        savedArticlesVC.indexPathRow = selectedRow
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
