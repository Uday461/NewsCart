//
//  HeaderView.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 16/07/23.
//

import Foundation
import UIKit
class HeaderView: UIView{
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var popButton: UIButton!
    
    var fetchCategoryNewsDelegate: FetchCategoryNews?
    
    var fetchInboxMessagesDelegate: FetchInboxMessages?
    
    var fetchCardsInboxMessagesDelegate: CardsInboxMessages?
    
    var fetchSelfHandledCardsInbox: FetchSelfHandledCards?
    //Following method is used to show the UIMenu() of various news categories.
    func setupPopButton(){
        let optionClosure = {(action: UIAction)->() in
            self.fetchCategoryNewsDelegate?.fetchCategoryNews(action.title)
        }
        popButton.menu = UIMenu(children: [
            UIAction(title: "All", state: .on, handler: optionClosure),
            UIAction(title: "Business", handler: optionClosure),
            UIAction(title: "Health", handler: optionClosure),
            UIAction(title: "Technology", handler: optionClosure),
            UIAction(title: "Science", handler: optionClosure),
            UIAction(title: "Sports", handler: optionClosure)
        ])
        popButton.showsMenuAsPrimaryAction = true
        popButton.changesSelectionAsPrimaryAction = true
    }
    
    
//    @IBAction func messageInboxButtonPressed(_ sender: Any) {
//        fetchInboxMessagesDelegate?.fetchInboxMessages()
//    }
//    
    
    @IBAction func bookMarkButtonPressed(_ sender: Any) {
        fetchCategoryNewsDelegate?.fetchSavedArticles()
    }
    
    
    @IBAction func cardsInboxButtonPressed(_ sender: Any) {
        fetchCardsInboxMessagesDelegate?.fetchCardsInboxMessages()
    }
    
    
//    @IBAction func selfCardsButtonPressed(_ sender: Any) {
//        fetchSelfHandledCardsInbox?.fetchSelfHandledCards()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: UIView.noIntrinsicMetric, height: 165)
    }
    
    private func commonInit(){
        let bundle  = Bundle(for: HeaderView.self)
        bundle.loadNibNamed(Identifiers.headerView, owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }
}
