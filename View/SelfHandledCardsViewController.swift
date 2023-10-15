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
    var selfHandledCardsArray: [SelfHandledModel] = []
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

extension SelfHandledCardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LogManager.logging("campaignArrayCount: \(selfHandledCardsArray.count)")
        return selfHandledCardsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selfHandledCardData = selfHandledCardsArray[indexPath.row]
        MoEngageSDKCards.sharedInstance.cardDelivered(self.selfHandledCardsArray[indexPath.row].moEngageCardCampaign, forAppID: Constants.appID)
        MoEngageSDKCards.sharedInstance.cardShown(self.selfHandledCardsArray[indexPath.row].moEngageCardCampaign, forAppID: Constants.appID)
        
        switch (selfHandledCardData.cardTemplateType) {
        case .basic:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.cardsCell) as! CardsCell
            if (selfHandledCardData.imageLink == nil) {
                cell.headerLabel.attributedText = selfHandledCardData.text[0]
                cell.headerLabel.font = UIFont.systemFont(ofSize: 16.0)
                cell.messageLabel.attributedText = selfHandledCardData.text[1]
                cell.messageLabel.font = UIFont.systemFont(ofSize: 16.0)
                cell.dateLabel.text = selfHandledCardData.dateOfCreation
                //      if let cardTemplateBgColor = selfHandledCardData.cardTemplateBgColor {
                //                    cell.cardTemplateView.backgroundColor = cardTemplateBgColor
                //                }  else {
                //                    cell.cardTemplateView.backgroundColor = UIColor(named: "selfHandledCards")
                //                }
                //                cell.backgroundColor =  ColorUtils.hexToRGB(hex: "#003390")
                cell.clickDelegate = self
                cell.cellIndex = indexPath
                if (selfHandledCardData.buttonName == nil) {
                    cell.buttonCTA.isHidden = true
                } else {
                    cell.buttonCTA.isHidden = false
                    if let attributedButtonTitle = StringUtils.returnNSMutableAttributedStringForButton(buttonName: selfHandledCardData.buttonName!) {
                        cell.buttonCTA.setAttributedTitle(attributedButtonTitle, for: .normal)
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.cardsBasicWithImageCell) as! CardsBasicWithImageCell
                cell.headerLabel.attributedText = selfHandledCardData.text[0]
                cell.headerLabel.font = UIFont.systemFont(ofSize: 16.0)
                cell.messageLabel.attributedText = selfHandledCardData.text[1]
                cell.messageLabel.font = UIFont.systemFont(ofSize: 16.0)
                cell.dateLabel.text = selfHandledCardData.dateOfCreation
                //     if let cardTemplateBgColor = selfHandledCardData.cardTemplateBgColor {
                //                    cell.cardTemplateView.backgroundColor = cardTemplateBgColor
                //                } else {
                //                    cell.cardTemplateView.backgroundColor = UIColor(named: "selfHandledCards")
                //                }
                //                cell.backgroundColor =  ColorUtils.hexToRGB(hex: "#003390")
                cell.clickDelegate = self
                cell.cellIndex = indexPath
                if (selfHandledCardData.buttonName == nil) {
                    cell.buttonCTA.isHidden = true
                } else {
                    cell.buttonCTA.isHidden = false
                    if let attributedButtonTitle = StringUtils.returnNSMutableAttributedStringForButton(buttonName: selfHandledCardData.buttonName!) {
                        cell.buttonCTA.setAttributedTitle(attributedButtonTitle, for: .normal)
                    }
                    
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
            
        case .illustration:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.cardsillustrationCell) as! CardsillustrationCell
            cell.headerLabel.attributedText = selfHandledCardData.text[0]
            cell.headerLabel.font = UIFont.systemFont(ofSize: 16.0)
            cell.clickDelegate = self
            cell.cellIndex = indexPath
            if (selfHandledCardData.text.count == 2) {
                cell.messageLabel.attributedText = selfHandledCardData.text[1]
                cell.messageLabel.font = UIFont.systemFont(ofSize: 16.0)
            } else {
                cell.messageLabel.isHidden = true
            }
            if (selfHandledCardData.buttonName == nil) {
                cell.buttonCTA.isHidden = true
            } else {
                cell.buttonCTA.isHidden = false
                if let attributedButtonTitle = StringUtils.returnNSMutableAttributedStringForButton(buttonName: selfHandledCardData.buttonName!) {
                    cell.buttonCTA.setAttributedTitle(attributedButtonTitle, for: .normal)
                }
                
            }
            cell.dateLabel.text = selfHandledCardData.dateOfCreation
            //            if let cardTemplateBgColor = selfHandledCardData.cardTemplateBgColor {
            //                cell.cardTemplateView.backgroundColor = cardTemplateBgColor
            //            } else {
            //                cell.cardTemplateView.backgroundColor = UIColor(named: "selfHandledCards")
            //            }
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
            
        case .none:
            break
            
        }
        
        return UITableViewCell()
    }
    
}

extension SelfHandledCardsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moEngageCardCampaign = selfHandledCardsArray[indexPath.row].moEngageCardCampaign
        let moEngageTemplateData = moEngageCardCampaign.templateData
        let moEngageContainer = moEngageTemplateData?.containers
        let actionTypeAndValue = selfHandledCardsArray[indexPath.row].actionTypeAndValue
        if let _moEngageContainer = moEngageContainer{
            let widget = _moEngageContainer[0].widgets
            for index in 0..<widget.count{
                let widgetId = widget[index].id
                MoEngageSDKCards.sharedInstance.cardClicked(moEngageCardCampaign, withWidgetID: widgetId);
            }
        }
        
        if let actionTypeAndValue = actionTypeAndValue{
            let buttonName = selfHandledCardsArray[indexPath.row].buttonName
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
                
                MoEngageSDKCards.sharedInstance.deleteCards([self.selfHandledCardsArray[indexPath.row].moEngageCardCampaign]) { isDeleted, accountMeta in
                    print("Card deletion was \(isDeleted)")
                    self.selfHandledCardsArray.remove(at: indexPath.row)
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
        if (selfHandledCardsArray[indexPath.row].cardTemplateType?.rawValue == Constants.SelfHandledCardsConstants.basic && (selfHandledCardsArray[indexPath.row].imageLink == nil)) {
            return 95
        } else if (selfHandledCardsArray[indexPath.row].cardTemplateType?.rawValue == Constants.SelfHandledCardsConstants.basic && (selfHandledCardsArray[indexPath.row].imageLink != nil)) {
            return 130
        } else if (selfHandledCardsArray[indexPath.row].cardTemplateType?.rawValue == Constants.SelfHandledCardsConstants.illustration){
            return 280
        }
        return 1
    }
}

extension SelfHandledCardsViewController: ClickDelegate{
    func clicked(_ row: Int, _ buttonState: String) {
        let actionTypeAndValue = selfHandledCardsArray[row].actionTypeAndValue
        if let actionTypeAndValue = actionTypeAndValue{
            SelfHandledManager.actionHandling(typeOfAction: actionTypeAndValue.typeOfAction, actionValue: actionTypeAndValue.actionValue)
        }
    }
}
