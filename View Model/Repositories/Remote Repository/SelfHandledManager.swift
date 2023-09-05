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
    var selfHandledData: [SelfHandledModel] = []
    var cardTemplateType: String? = nil
    var imageLink: String? =  nil
    var text = [String]()
    var typeOfAction = [String]()
    var actionValue = [String]()
    var dateInString: String = ""
    func returnSelfHandledData(moEngageCardCampaignArray: [MoEngageCardCampaign])-> [SelfHandledModel]{
        for itr in 0..<moEngageCardCampaignArray.count{
            if let date = moEngageCardCampaignArray[itr].createdDate{
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .short
                dateInString = dateFormatter.string(from: date)
            }
            let templateData = moEngageCardCampaignArray[itr].templateData
            let cardContainer = templateData?.containers
            print(cardContainer?.count)
            for index in 0..<(cardContainer?.count ?? 0){
                let cardWidget = cardContainer?[index].widgets
                if let actions = cardContainer?[index].actions {
                    for index in 0..<(actions.count){
                        typeOfAction.append(actions[index].typeString)
                        actionValue.append(actions[index].value)
                    }
                }
                cardTemplateType = cardContainer?[index].typeString
                for i in 0..<(cardWidget?.count ?? 0){
                    if let typeString = cardWidget?[i].typeString, let widgetContent = cardWidget?[i].content{
                        if (typeString == "image"){
                            imageLink = widgetContent
                        } else if (typeString == "text"){
                            var widgetModified = widgetContent.deletingPrefix("<div>")
                            widgetModified = widgetModified.deletingSuffix("</div>")
                            text.append(widgetModified)
                        }
                        print(typeString)
                        print(widgetContent)
                    }
                }
                var check:Bool = false
                for index in 0..<text.count{
                    check = check || text[index].hasPrefix("<")
                }
                if (check == false){
                    let selfHandledCardDetails = SelfHandledModel(cardTemplateType: cardTemplateType, imageLink: imageLink, text: text, dateOfCreation: dateInString, typeOfAction: typeOfAction, actionValue: actionValue, moEngageCardCampaign: moEngageCardCampaignArray[itr])
                    selfHandledData.append(selfHandledCardDetails)
                    imageLink = nil
                    text.removeAll()
                    typeOfAction.removeAll()
                    actionValue.removeAll()
                }
            }
        }
        return selfHandledData
    }
    
    func actionHandling(typeOfAction: String, actionValue: String){
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

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}
