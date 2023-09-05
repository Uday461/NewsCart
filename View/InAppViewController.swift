//
//  InAppViewController.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 31/08/23.
//

import UIKit
import MoEngageInApps
class InAppViewController: UIViewController {
    
    var inAppText: String?
    var campaignInfo: MoEngageInAppSelfHandledCampaign? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        if let _campaigInfo = campaignInfo{
            MoEngageSDKInApp.sharedInstance.selfHandledShown(campaignInfo: _campaigInfo)
        }
        // Do any additional setup after loading the view.
        inAppLabel.text = inAppText
        Timer.scheduledTimer(timeInterval:30, target: self, selector: #selector(InAppViewController.dismissButtonPressed(_:)), userInfo: nil, repeats: false)
    }

    @IBOutlet weak var inAppLabel: UILabel!
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
        if let _campaignInfo = campaignInfo{
            MoEngageSDKInApp.sharedInstance.selfHandledDismissed(campaignInfo: _campaignInfo)
        }
    }
}

