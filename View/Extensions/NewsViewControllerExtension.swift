//
//  NewsAPIViewControllerExtensions.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 30/07/23.
//

import Foundation
import UIKit
import SafariServices

//MARK: - FetchNews Protocol Methods

extension NewsViewController: FetchNews{

//Following method is used to handle the error when URLSession requesting fails and display alert to user.
    func didFailErrorDueToNetwork(_ networkError: Error) {
        LogManager.log(networkError, logType: .error)
        let alert = AlertsManager.alertMessage(error: networkError)
        present(alert, animated: true, completion: nil)
    }
    
//Following method is used for checking valid articles and updating "articles" variable.
    func fetchAndUpdateNews(_ apiNewsModel: APINewsModel) {
        self.apiNewsModel = apiNewsModel
        totalArticles = totalArticles + apiNewsModel.articles.count
        guard let _validArticles = apiNewsManager.validArticlesList(articles: apiNewsModel.articles) else{
            LogManager.log("Valid Articles is nil", logType: .error)
            return }
        LogManager.log("Total Articles:\(self.totalArticles)", logType: .info)
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

//MARK: - FetchCategoryNews Protocol Methods

extension NewsViewController: FetchCategoryNews{
    //Following method is used for fetching the selected category news.
    func fetchCategoryNews(_ category: String) {
        page = 1
        invalidArticlesCount = 0
        LogManager.log("Selected news category: \(category)", logType: .info)
        if (category != "All"){
            let categoryQuery = apiNewsManager.categoryConstants(category: category)!
            apiNewsManager.apiRequest(urlToImage: "\(APIEndPoints.apiForFetchingCategoryNews)\(categoryQuery)&page=\(page)") { data, response, error, count in
                if let _data = data{
                    self.apiNewsManager.parseJSON(data: _data)
                } else if let _error = error{
                    DispatchQueue.main.async {
                        self.didFailErrorDueToNetwork(_error)
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            apiNewsManager.apiRequest(urlToImage: "\(APIEndPoints.apiForFetchingNews)\(page)") { data, response, error, count in
                if let _data = data{
                    self.apiNewsManager.parseJSON(data: _data)
                } else if let _error = error{
                    DispatchQueue.main.async {
                        self.didFailErrorDueToNetwork(_error)
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
            cell.saveImageView.image = UIImage(systemName: "bookmark")
        } else {
            cell.saveImageView.image = UIImage(systemName: "bookmark.fill")
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
            apiNewsManager.apiRequest(urlToImage: urlToImage, key: fileName) { data, response, error, fileName in
             var imageType = ""
                    if let _data = data{
                        DispatchQueue.main.async {
                            let imageFetched: UIImage = UIImage(data: _data) ?? UIImage(named: Constants.noImage)!
                            cell.newsImage.image = imageFetched
                            if (_data.format() == .jpg){
                                imageType = ".jpg"
                            } else if (_data.format() == .png){
                                imageType = ".png"
                            }
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
            LogManager.log("Selected news article url contains nil.", logType: .error)
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let _articles = articles{
            if (indexPath.row == _articles.count-1){
                LogManager.log("Articles fetched page wise: \(_articles.count)", logType: .info)
                LogManager.log("invalid Articles Count: \(self.invalidArticlesCount)", logType: .info)
                if (_articles.count < (apiNewsModel!.totalResults - invalidArticlesCount)){
                    page = page + 1
                    apiNewsManager.apiRequest(urlToImage: "\(APIEndPoints.apiForFetchingNews)\(page)") { data, response, error, count in
                        if let _data = data{
                            self.apiNewsManager.parseJSON(data: _data)
                        } else if let _error = error{
                            DispatchQueue.main.async {
                                self.didFailErrorDueToNetwork(_error)
                            }
                        }
                    }
                } else {
                    LogManager.log("All the valid news updates has been fetched.", logType: .info)
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
        if (buttonState == "save"){
            let newArticle = ArticleInfo(context: context)
            newArticle.newsTitle = articles?[row].title
            newArticle.newsDescritption = articles?[row].description
            newArticle.sourceName = articles?[row].source.name
            newArticle.urlLink = articles?[row].url
            newArticle.newsImage = imagesDictionary[(articles?[row].url)!]?.data
            guard let uiImage = UIImage(data: imagesDictionary[(articles?[row].url)!]!.data), let imageFormat = imagesDictionary[(articles?[row].url)!]?.imageFormat, let key = imagesDictionary[(articles?[row].url)!]?.key else {
                LogManager.log("Optional variable contains nil.", logType: .error)
                return
            }
            newArticle.imageName = key+imageFormat
            fileSystemManager.store(image: uiImage, forImageName: key+imageFormat, imageFormat: imageFormat)
            LogManager.log("News article is saved.", logType: .info)
        } else {
            fetchSavedArticle = coreDataManager.fetchSavedArticle(urlLink: (articles?[row].url)!)
            if let _imageName = fetchSavedArticle[0].imageName{
                fileSystemManager.deleteImage(forImageName: _imageName)
            }
            coreDataManager.deleteArticle(articleInfo: fetchSavedArticle[0])
            LogManager.log("News article is unsaved.", logType: .info)
        }
        coreDataManager.saveArticle()
    }
}



