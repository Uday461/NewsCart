//
//  SelfHandledModel.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 01/09/23.
//

import Foundation
import MoEngageCards
struct SelfHandledModel{
    let cardTemplateType: String?
    let imageLink: String?
    let text: [String]
    let dateOfCreation: String
    let actionTypeAndValue: ActionTypeAndValue?
    let buttonName: String?
    let moEngageCardCampaign: MoEngageCardCampaign
}

struct ActionTypeAndValue{
    var typeOfAction:String
    var actionValue: String
}
