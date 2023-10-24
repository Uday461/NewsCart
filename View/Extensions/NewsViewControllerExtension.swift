//
//  NewsAPIViewControllerExtensions.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 30/07/23.
//

import Foundation
import UIKit
import SafariServices
import MoEngageSDK
import MoEngageInbox
import MoEngageCards
import MoEngageInApps

//MARK: - FetchNews Protocol Methods

extension NewsViewController: FetchNews{
    //Following method is used to handle the error when URLSession requesting fails and display alert to user.
    func didFailErrorDueToNetwork(_ networkError: Error) {
        LogManager.error(networkError.localizedDescription)
        let alert = AlertsManager.alertMessage(error: networkError)
        present(alert, animated: true, completion: nil)
    }
    
    //Following method is used for checking valid articles and updating "articles" variable.
    func fetchAndUpdateNews(_ apiNewsModel: APINewsModel) {
        self.apiNewsModel = apiNewsModel
        totalArticles = totalArticles + apiNewsModel.articles.count
        guard let _validArticles = apiNewsManager.validArticlesList(articles: apiNewsModel.articles) else{
            LogManager.error("Valid Articles is nil")
            isPaginationComplete = true
            loadMoreData()
            return
        }
        LogManager.logging("Total Articles:\(self.totalArticles)")
        if (page == 1){
            self.articles = _validArticles
            invalidArticlesCount = invalidArticlesCount + (apiNewsModel.articles.count - (articles?.count ?? 0))
        } else{
            
            self.articles?.append(contentsOf: _validArticles)
            invalidArticlesCount = invalidArticlesCount + (apiNewsModel.articles.count - (_validArticles.count))
        }
        if let _articles = articles, _articles.count == (apiNewsModel.totalResults - invalidArticlesCount) {
            isPaginationComplete = true
        }
        loadMoreData()
        
    }
    
}

//MARK: - FetchInboxMessages Protocol Methods

extension NewsViewController: FetchInboxMessages{
    func fetchInboxMessages() {
        MoEngageSDKInbox.sharedInstance.pushInboxViewController(toNavigationController: self.navigationController!, withUIConfiguration: MoEngageInboxConfiguration.getMoEngageInboxConfiguration(), withInboxWithControllerDelegate: self)
    }
    
}

//MARK: - FetchCardsInboxMessages Protocol Methods

extension NewsViewController: CardsInboxMessages{
    func fetchCardsInboxMessages() {
        MoEngageSDKCards.sharedInstance.pushCardsViewController(toNavigationController: self.navigationController!, withUIConfiguration: nil, withCardsViewControllerDelegate: self)
    }
}

//MARK: - FetchSelfHandledCards Protocol Methods

extension NewsViewController: FetchSelfHandledCards{
    func fetchSelfHandledCards() {
        performSegue(withIdentifier: "goToSelfCards", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToSelfCards"){
            let selfHandledCardsVC = segue.destination as! SelfHandledCardsViewController
            let selfHandledManager = SelfHandledManager(moEngageCards: moEngageCardsCampaignArray)
            let selfHandledCardsArray = selfHandledManager.returnSelfHandledData()
            let selfHandledVM = SelfHandledViewModel(selfHandledModel: selfHandledCardsArray)
            selfHandledCardsVC.selfHandledCardsArray = selfHandledVM.getSelfHandledVM()
        }
    }
}



//MARK: - MoEngageCards Callback methods

extension NewsViewController: MoEngageCardsViewControllerDelegate{
    // Called when MoEngageCardsListViewController is dismissed after being presented
    @objc func cardsViewControllerDismissed(forAccountMeta accountMeta: MoEngageAccountMeta){
        LogManager.logging("CardsViewController Dismissed: \(accountMeta.appID)")
    }
    // Called when a Card is deleted
    @objc func cardDeleted(withCardInfo card: MoEngageCardCampaign, forAccountMeta accountMeta: MoEngageAccountMeta){
        LogManager.logging("Cards is deleted: \(accountMeta.appID)")
    }
    // Called when a Card is clicked by the user
    @objc func cardClicked(withCardInfo card: MoEngageCardCampaign, andAction action:MoEngageCardAction, forAccountMeta accountMeta: MoEngageAccountMeta) -> Bool{
        LogManager.logging("Card is clicked by the user: \(accountMeta.appID)")
        if (action.typeString == "screenName"){
            NavigatingToScreen.navigatingToOtherScreen(toScreen: action.value)
        }
        return true
    }
}
//MARK: - MoEngageIOSNotificationCentre callback methods

extension NewsViewController{
    
    //Called when inbox cell is selected
    func inboxEntryClicked(_ inboxItem: MoEngageInboxEntry) {
        LogManager.logging("Inbox item clicked")
        LogManager.logging("Is Read: \(inboxItem.isRead)")
        if !inboxItem.isRead {
            MoEngageSDKInbox.sharedInstance.markInboxNotificationClicked(withCampaignID: inboxItem.campaignID!)
            MoEngageSDKInbox.sharedInstance.getInboxMessages(forAppID:Constants.appID) { inboxMessages, account in
                print("Received Inbox messages")
                print(inboxMessages)
            }
            
        }
        
        //Called when inbox item is deleted
        func inboxEntryDeleted(_ inboxItem: MoEngageInboxEntry) {
            LogManager.logging("Inbox item deleted")
        }
        
        // Called when MoEngageInboxViewController is dismissed after being presented
        func inboxViewControllerDismissed() {
            LogManager.logging("Dismissed")
        }
        
    }
}

//MARK: - FetchCategoryNews Protocol Methods

extension NewsViewController: FetchCategoryNews{
    //Following method is used for fetching the selected category news.
    func fetchCategoryNews(_ category: String) {
        page = 1
        invalidArticlesCount = 0
        LogManager.logging("Selected news category: \(category)")
        apiNewsManager.fetchSelectedCategoryNews(category: category, page: page)
    }
    //Following method is used for fetching saved news articles.
    func fetchSavedArticles() {
        let articlesPersisted = coreDataManager.loadArticles()
        performSegue(withIdentifier: Identifiers.goToSavedArticlesVC, sender: self)
    }
}

//MARK: - UITableViewDataSource Methods

extension NewsViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return articles?.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellSection = indexPath.section
        switch (cellSection) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.newsCell) as! CustomNewsCell
            cell.clickDelegate = self
            cell.cellIndex = indexPath
            if let urlLink = (articles?[indexPath.row].url) {
                fetchSavedArticle = coreDataManager.fetchSavedArticle(urlLink: urlLink)
            }
            if (fetchSavedArticle.count == 0){
                cell.saveImageView.image = UIImage(systemName: Identifiers.systemName.bookmark)
            } else {
                cell.saveImageView.image = UIImage(systemName: Identifiers.systemName.bookmarkfill)
            }
            
            cell.newsTitle.text = articles?[indexPath.row].title
            cell.newsDescription.text = articles?[indexPath.row].description
            if let source = articles?[indexPath.row].source.name{
                cell.newsSource.text = source
            } else{
                cell.newsSource.text = "No Source."
            }
            let fileName = fileSystemManager.generateUniqueFilename(forUrlString: (articles?[indexPath.row].url)!)
            if let urlToImage = articles?[indexPath.row].urlToImage, let fileName = fileName{
                apiNewsManager.apiRequest(url: urlToImage, key: fileName) { data, response, error, fileName in
                    var imageType = ""
                    if let _data = data{
                        DispatchQueue.main.async {
                            let imageFetched: UIImage = UIImage(data: _data) ?? UIImage(named: Constants.noImage)!
                            cell.newsImage.image = imageFetched
                            imageType = ImageExtension.returnImageExtension(imageFormat: _data.format())
                            print(imageType)
                            let imageProperty = ImagePropertyModel(data: _data, key: fileName, imageFormat: imageType)
                            self.imagesDictionary[(self.articles?[indexPath.row].url)!] = imageProperty
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            cell.newsImage.image = UIImage(named: Constants.noImage)
                            let imageData = UIImage(named: Constants.noImage)?.pngData()
                            guard let _imageData = imageData else {return}
                            let imageProperty = ImagePropertyModel(data: _imageData, key: fileName, imageFormat: ".png")
                            self.imagesDictionary[(self.articles?[indexPath.row].url)!] = imageProperty
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    cell.newsImage.image = UIImage(named: Constants.noImage)
                    let imageData = UIImage(named: Constants.noImage)?.pngData()
                    guard let _imageData = imageData, let fileName = fileName else {return}
                    let imageProperty = ImagePropertyModel(data: _imageData, key: fileName, imageFormat: ".png")
                    self.imagesDictionary[(self.articles?[indexPath.row].url)!] = imageProperty
                }
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingcellid", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
            
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140 // Item Cell height
        } else {
            return isPaginationComplete ? 0 : 140 // Loading Cell height
        }
    }
}

//MARK: - UITableViewDelegate Methods

extension NewsViewController:  UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newsUrl = articles?[indexPath.row].url
        guard let url = URL(string: newsUrl ?? "") else{
            LogManager.error("Selected news article url contains nil.")
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let _articles = articles{
            if (indexPath.row == _articles.count-1){
                LogManager.logging("Articles fetched page wise: \(_articles.count)")
                LogManager.logging("invalid Articles Count: \(self.invalidArticlesCount)")
                if (_articles.count < (apiNewsModel!.totalResults - invalidArticlesCount)){
                    page = page + 1
                    apiNewsManager.fetchNews(newsUrl: "\(APIEndPoints.apiForFetchingNews)\(page)")
                } else {
                    LogManager.logging("All the valid news updates has been fetched.")
                    let alert = AlertsManager.alertMessageForNewsUpdate()
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: - SetUp HeaderView Methods
    func setupTableHeaderView(){
        let title = "Your daily news updates are here!.."
        var char = 0.0
        header.label.text = ""
        for letter in title{
            Timer.scheduledTimer(withTimeInterval: 0.1*char, repeats: false) { timer in
                self.header.label.text?.append(letter)
            }
            char+=1
        }
        var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        header.frame.size = size
        
        size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        header.frame.size = size
        
        tableView.tableHeaderView = header
    }
    
}

//MARK: - ClickDelegate Protocol Methods

extension NewsViewController: ClickDelegate{
    //Following is method used to handle the case of "saving"/"unsaving" a news article.
    func clicked(_ row: Int, _ buttonState: String) {
        if (buttonState == Identifiers.save){
            guard let uiImage = UIImage(data: imagesDictionary[(articles?[row].url)!]!.data), let imageFormat = imagesDictionary[(articles?[row].url)!]?.imageFormat, let key = imagesDictionary[(articles?[row].url)!]?.key else {
                LogManager.error("Optional variable contains nil.")
                return
            }
            let newArticle = coreDataManager.articleInfoModel(imageName: key+imageFormat, newsDescription: (articles?[row].description)!, newsTitle: (articles?[row].title!)!, sourceName: articles?[row].source.name, urlLink: (articles?[row].url)!)
            LogManager.logging("ImageFileName: \(key+imageFormat)")
            
            guard let url = articles?[row].url, let _imageURL = articles?[row].urlToImage else {
                return
            }
            fileSystemManager.store(image: uiImage, forImageName: key, imageFormat: imageFormat)
        } else {
            fetchSavedArticle = coreDataManager.fetchSavedArticle(urlLink: (articles?[row].url)!)
            if let _imageName = fetchSavedArticle[0].imageName {
                fileSystemManager.deleteImage(forImageName: _imageName)
            }
            coreDataManager.deleteArticle(articleInfo: fetchSavedArticle[0])
            LogManager.logging("News article is unsaved.")
        }
        coreDataManager.saveArticle()
    }
}



