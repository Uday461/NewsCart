//
//  SelfHandledManager.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 01/09/23.
//

import Foundation
import MoEngageCards
import UIKit
class SelfHandledManager{
    private var selfHandledData: [SelfHandledModel] = []
    private var cardTemplateType: CardType?
    private var imageLink: String? =  nil
    private var text = [NSAttributedString]()
    private var typeOfAction: String?
    private var actionValue:String?
    private var dateInString: String = ""
    private var moEngageCardCampaignArray = [MoEngageCardCampaign]()
    private var cardTemplateBgColor:UIColor? = nil
    private var actionTypeAndValue: ActionTypeAndValue? = nil
    private var buttonName: NSAttributedString? = nil
    init (moEngageCards: [MoEngageCardCampaign]) {
        self.moEngageCardCampaignArray = moEngageCards
    }
    
    func returnSelfHandledData()-> [SelfHandledModel] {
        for itr in 0..<moEngageCardCampaignArray.count {
            if let date = moEngageCardCampaignArray[itr].createdDate {
                dateInString = DateUtils.dateInStringFormat(date: date)
            }
            let templateData = moEngageCardCampaignArray[itr].templateData
            let cardContainer = templateData?.containers
            for index in 0..<(cardContainer?.count ?? 0) {
                let cardWidget = cardContainer?[index].widgets
                cardTemplateBgColor = cardContainer?[index].style?.bgColor
                if (cardContainer?[index].typeString == Constants.SelfHandledCardsConstants.basic) {
                    cardTemplateType = .basic } else {
                    cardTemplateType = .illustration
                }
                if let actions = cardContainer?[index].actions {
                    for index in 0..<(actions.count) {
                        typeOfAction = actions[index].typeString
                        actionValue = actions[index].value
                    }
                }
                for i in 0..<(cardWidget?.count ?? 0) {
                    if let typeString = cardWidget?[i].typeString, let widgetContent = cardWidget?[i].content{
                        switch(typeString) {
                        case CardWidgetType.image.rawValue:
                            imageLink = widgetContent
                            break
                            
                        case CardWidgetType.text.rawValue:
                            if let attributedString = StringUtils.returnNSAttributedString(widgetContent: widgetContent){
                                text.append(attributedString)
                            }
                            break
                            
                        case CardWidgetType.button.rawValue:
                            let actions = cardWidget?[i].actions
                            if let actions = actions?[0] {
                                if let attributedString = StringUtils.returnNSAttributedString(widgetContent: widgetContent){
                                    buttonName = attributedString
                                }
                                typeOfAction = actions.typeString
                                actionValue = actions.value
                            }
                        default:
                            continue
                        }
                        
                    }
                }
                if let actionValue = actionValue, let typeOfAction = typeOfAction {
                    actionTypeAndValue = ActionTypeAndValue(typeOfAction: typeOfAction, actionValue: actionValue )
                }
                let selfHandledCardDetails = SelfHandledModel(cardTemplateType: cardTemplateType, imageLink: imageLink, text: text, dateOfCreation: dateInString, actionTypeAndValue: actionTypeAndValue, buttonName: buttonName, cardTemplateBgColor: cardTemplateBgColor, moEngageCardCampaign: moEngageCardCampaignArray[itr])
                selfHandledData.append(selfHandledCardDetails)
                imageLink = nil
                typeOfAction = nil
                actionValue = nil
                actionTypeAndValue = nil
                buttonName = nil
                cardTemplateBgColor = nil
                text.removeAll()
            }
        }
        return selfHandledData
    }
    
    static func actionHandling(typeOfAction: String, actionValue: String){
        if ((typeOfAction == "deepLink") || (typeOfAction == "richLanding")){
            if let url = URL(string: actionValue){
                UIApplication.shared.open(url) { (result) in
                    if result {
                        LogManager.logging("DeepLink URL delivered successfully!")
                    } else {
                        LogManager.error("Error in DeepLink URL delivery")
                    }
                }
            }
        } else if (typeOfAction == "screenName"){
            NavigatingToScreen.navigatingToOtherScreen(toScreen: actionValue)
        }
    }
    
}
