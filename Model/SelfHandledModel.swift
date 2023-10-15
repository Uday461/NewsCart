//
//  SelfHandledModel.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 01/09/23.
//

import Foundation
import MoEngageCards
import UIKit

struct SelfHandledModel {
    let cardTemplateType: CardType?
    let imageLink: String?
    let text: [NSAttributedString]
    let dateOfCreation: String
    let actionTypeAndValue: ActionTypeAndValue?
    let buttonName: NSAttributedString?
    let cardTemplateBgColor: UIColor?
    let moEngageCardCampaign: MoEngageCardCampaign
}

struct ActionTypeAndValue {
    var typeOfAction:String
    var actionValue: String
}
