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
import FileManagementSDK

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
            return }
        LogManager.logging("Total Articles:\(self.totalArticles)")
        if (page == 1){
            self.articles = _validArticles
            invalidArticlesCount = invalidArticlesCount + (apiNewsModel.articles.count - (articles?.count ?? 0))
        } else{
            
            self.articles?.append(contentsOf: _validArticles)
            invalidArticlesCount = invalidArticlesCount + (apiNewsModel.articles.count - (_validArticles.count))
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
            let selfHandledCardsVC = segue.destination as! SelfHandledInAppViewController
            selfHandledCardsVC.moEngageCardCampaignArray = moEngageCardsCampaignArray
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
        if (articlesPersisted.count == 0){
            performSegue(withIdentifier: Identifiers.goToEmptyVC, sender: self)
        } else{
            performSegue(withIdentifier: Identifiers.goToSavedArticlesVC, sender: self)
        }
    }
}

//MARK: - UITableViewDataSource Methods

extension NewsViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.newsCell) as! CustomNewsCell
        cell.clickDelegate = self
        cell.cellIndex = indexPath
        fetchSavedArticle = coreDataManager.fetchSavedArticle(urlLink:(articles?[indexPath.row].url)!)
        
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
          //  fileSystemManager.store(image: uiImage, forImageName: key+imageFormat, imageFormat: imageFormat)
            LogManager.logging("ImageFileName: \(key+imageFormat)")
           
            guard let url = articles?[row].url, let _imageURL = articles?[row].urlToImage else {
                return
            }
            let fileManager = FileManager.default
            guard let documentURL = fileManager.urls(for: .documentDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first else {
                LogManager.error("Error: File doesn't exit.")
                return
            }
            print(documentURL)
            var fileManagmentSDK = FileManagementSDK(fileURL: documentURL)
            fileManagmentSDK.store(newsURL: url, imageURL: _imageURL) { result in
                switch result {
                case .success(let imageFileName):
                    LogManager.logging("ImageFile saved Successfully!: \(imageFileName)")
                case .failure(let error):
                    LogManager.error("ImageFile is not saved: \(error.getErrorDescription())")
                }
            }
        } else {
            let fileManager = FileManager.default
            guard let documentURL = fileManager.urls(for: .documentDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first else {
                LogManager.error("Error: File doesn't exit.")
                return
            }
            print(documentURL)
            var fileManagmentSDK = FileManagementSDK(fileURL: documentURL)
            
            fetchSavedArticle = coreDataManager.fetchSavedArticle(urlLink: (articles?[row].url)!)
            if let _imageName = fetchSavedArticle[0].imageName{
            let result = fileManagmentSDK.deleteImage(forImageName: _imageName)
            switch result{
            case .success(let success):
                LogManager.logging(success)
            case .failure(let error):
                LogManager.error(error.getErrorDescription())
            }
            }
            coreDataManager.deleteArticle(articleInfo: fetchSavedArticle[0])
            LogManager.logging("News article is unsaved.")
        }
        coreDataManager.saveArticle()
    }
}



