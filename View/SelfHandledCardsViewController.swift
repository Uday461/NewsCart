//
//  SelfHandledInAppViewController.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 31/08/23.
//

import UIKit
import MoEngageCards

class SelfHandledCardsViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var cardsCount: Int? = nil
    var moEngageCardCampaignArray:[MoEngageCardCampaign] = []
    var selfHandledData: [SelfHandledModel] = []
    let apiManager = APINewsManager()
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let selfCardViewBasic = UINib(nibName: "SelfCardViewBasic", bundle: Bundle.main)
        tableView.register(selfCardViewBasic, forCellReuseIdentifier: "selfCardBasicViewCell")
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressRecognizer)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
}

extension SelfHandledCardsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LogManager.logging("campaignArrayCount: \(selfHandledData.count)")
        return selfHandledData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selfHandledCardData = selfHandledData[indexPath.row]
        MoEngageSDKCards.sharedInstance.cardDelivered(self.selfHandledData[indexPath.row].moEngageCardCampaign, forAppID: Constants.appID)
        MoEngageSDKCards.sharedInstance.cardShown(self.selfHandledData[indexPath.row].moEngageCardCampaign, forAppID: Constants.appID)
        
        if (selfHandledCardData.cardTemplateType == "basic"){
            if (selfHandledCardData.imageLink == nil){
                let cell = tableView.dequeueReusableCell(withIdentifier: "cardsCell") as! CardsCell
                cell.headerLabel.text = selfHandledCardData.text[0]
                cell.messageLabel.text = selfHandledCardData.text[1]
                cell.dateLabel.text = selfHandledCardData.dateOfCreation
                cell.clickDelegate = self
                cell.cellIndex = indexPath
                if (selfHandledCardData.buttonName == nil){
                    cell.buttonCTA.isHidden = true
                } else {
                    let buttonTitle = NSAttributedString(string: uiButtonConfiguration(title: selfHandledCardData.buttonName!), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)])
                    cell.buttonCTA.setAttributedTitle(buttonTitle, for: .normal)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cardsBasicWithImageCell") as! CardsBasicWithImageCell
                cell.headerLabel.text = selfHandledCardData.text[0]
                cell.messageLabel.text = selfHandledCardData.text[1]
                cell.dateLabel.text = selfHandledCardData.dateOfCreation
                cell.clickDelegate = self
                cell.cellIndex = indexPath
                if (selfHandledCardData.buttonName == nil){
                    cell.buttonCTA.isHidden = true
                } else {
                    let buttonTitle = NSAttributedString(string: uiButtonConfiguration(title: selfHandledCardData.buttonName!), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)])
                    cell.buttonCTA.setAttributedTitle(buttonTitle, for: .normal)
                }
                guard let url = selfHandledCardData.imageLink else {
                    return cell
                }
                apiManager.apiRequest(url: url) { data, response, error, key in
                    if let data = data{
                        DispatchQueue.main.async {
                            cell.cardImage.image = UIImage(data: data)
                        }
                    }
                }
                return cell
            }
        }
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardsillustrationCell") as! CardsillustrationCell
            cell.headerLabel.text = selfHandledCardData.text[0]
            if (selfHandledCardData.text.count == 2){
                cell.messageLabel.text = selfHandledCardData.text[1]
            } else {
                cell.messageLabel.isHidden = true
            }
            if (selfHandledCardData.buttonName == nil){
                cell.buttonCTA.isHidden = true
            } else {
                let buttonTitle = NSAttributedString(string: uiButtonConfiguration(title: selfHandledCardData.buttonName!), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)])
                cell.buttonCTA.setAttributedTitle(buttonTitle, for: .normal)
            }
            cell.dateLabel.text = selfHandledCardData.dateOfCreation
            guard let url = selfHandledCardData.imageLink else {
                return cell
            }
            
            apiManager.apiRequest(url: url) { data, response, error, key in
                if let data = data{
                    DispatchQueue.main.async {
                        cell.cardImage.image = UIImage(data: data)
                    }
                }
            }
        
        return cell
    }
    
}

extension SelfHandledCardsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moEngageCardCampaign = selfHandledData[indexPath.row].moEngageCardCampaign
        let moEngageTemplateData = moEngageCardCampaign.templateData
        let moEngageContainer = moEngageTemplateData?.containers
        let actionTypeAndValue = selfHandledData[indexPath.row].actionTypeAndValue
        if let _moEngageContainer = moEngageContainer{
            let widget = _moEngageContainer[0].widgets
            for index in 0..<widget.count{
                let widgetId = widget[index].id
                MoEngageSDKCards.sharedInstance.cardClicked(moEngageCardCampaign, withWidgetID: widgetId);
            }
        }
        
        if let actionTypeAndValue = actionTypeAndValue{
            let buttonName = selfHandledData[indexPath.row].buttonName
            if (buttonName == nil) {
                SelfHandledManager.actionHandling(typeOfAction: actionTypeAndValue.typeOfAction, actionValue: actionTypeAndValue.actionValue)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: location) {
            let alertController = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                self.count += 1
                
                MoEngageSDKCards.sharedInstance.deleteCards([self.selfHandledData[indexPath.row].moEngageCardCampaign]) { isDeleted, accountMeta in
                    print("Card deletion was \(isDeleted)")
                    self.selfHandledData.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (selfHandledData[indexPath.row].cardTemplateType == "basic" && (selfHandledData[indexPath.row].imageLink == nil)){
            return 95
        } else if (selfHandledData[indexPath.row].cardTemplateType == "basic" && (selfHandledData[indexPath.row].imageLink != nil)){
            return 130
        } else if (selfHandledData[indexPath.row].cardTemplateType == "illustration"){
            return 280
        }
        return 1
    }
}

extension SelfHandledCardsViewController: ClickDelegate{
    func clicked(_ row: Int, _ buttonState: String) {
        let actionTypeAndValue = selfHandledData[row].actionTypeAndValue
        if let actionTypeAndValue = actionTypeAndValue{
            SelfHandledManager.actionHandling(typeOfAction: actionTypeAndValue.typeOfAction, actionValue: actionTypeAndValue.actionValue)
        }
    }
}

extension SelfHandledCardsViewController{
    func uiButtonConfiguration(title: String)-> String{
        var text = title // Replace with user input
        let maxLength = 20 // Replace with desired maximum length
        if title.count > maxLength {
           text = title.prefix(maxLength) + "..."
        }
        return text
    }
}
