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
        LogManager.e(networkError)
        let alert = UIAlertController(title: "Error!!.", message: "\(networkError.localizedDescription)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
//Following method is used for checking valid articles and updating "articles" variable.

    func fetchAndUpdateNews(_ apiNewsModel: APINewsModel) {
        self.apiNewsModel = apiNewsModel
        totalArticles = totalArticles + apiNewsModel.articles.count
        LogManager.i("Total Articles:\(self.totalArticles)")
        if (page == 1){
            self.articles = apiNewsManager.validArticlesList(articles: apiNewsModel.articles)
            invalidArticlesCount = invalidArticlesCount + (apiNewsModel.articles.count - (articles?.count ?? 0))
        } else{
            if let _validArticles = apiNewsManager.validArticlesList(articles: apiNewsModel.articles){
                self.articles?.append(contentsOf: _validArticles)
                invalidArticlesCount = invalidArticlesCount + (apiNewsModel.articles.count - (_validArticles.count))
            }
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
        LogManager.i("Selected news category: \(category)")
        if (category != "All"){
            let categoryQuery = apiNewsManager.categoryConstants(category: category)!
            apiNewsManager.apiRequest(urlToImage: "\(Constants.apiForFetchingCategoryNews)\(categoryQuery)&page=\(page)") { data, response, error, count in
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
            apiNewsManager.apiRequest(urlToImage: "\(Constants.apiForFetchingNews)\(page)") { data, response, error, count in
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
            performSegue(withIdentifier: Constants.goToEmptyVC, sender: self)
        } else{
            performSegue(withIdentifier: Constants.goToSavedArticlesVC, sender: self)
        }
    }
}

//MARK: - UITableViewDataSource Methods

extension NewsViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCell) as! CustomNewsCell
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
                            let imageProperty = ImageProperty(data: _data, key: fileName, imageFormat: imageType)
                            self.imagesDictionary[(self.articles?[indexPath.row].url)!] = imageProperty
                        }
                    }
                 else{
                    DispatchQueue.main.async {
                        cell.newsImage.image = UIImage(named: Constants.noImage)
                        let imageData = UIImage(named: Constants.noImage)?.pngData()
                        guard let _imageData = imageData else {return}
                        let imageProperty = ImageProperty(data: _imageData, key: fileName, imageFormat: ".png")
                        self.imagesDictionary[(self.articles?[indexPath.row].url)!] = imageProperty
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                cell.newsImage.image = UIImage(named: Constants.noImage)
                let imageData = UIImage(named: Constants.noImage)?.pngData()
                guard let _imageData = imageData, let fileName = fileName else {return}
                let imageProperty = ImageProperty(data: _imageData, key: fileName, imageFormat: ".png")
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
            LogManager.e("Selected news article url contains nil.")
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let _articles = articles{
            if (indexPath.row == _articles.count-1){
                LogManager.i("Articles fetched page wise: \(_articles.count)")
                LogManager.i("invalid Articles Count: \(self.invalidArticlesCount)")
                if (_articles.count < (apiNewsModel!.totalResults - invalidArticlesCount)){
                    page = page + 1
                    apiNewsManager.apiRequest(urlToImage: "\(Constants.apiForFetchingNews)\(page)") { data, response, error, count in
                        if let _data = data{
                            self.apiNewsManager.parseJSON(data: _data)
                        } else if let _error = error{
                            DispatchQueue.main.async {
                                self.didFailErrorDueToNetwork(_error)
                            }
                        }
                    }
                } else {
                    LogManager.i("All the valid news updates has been fetched.")
                    let imageAttachment = NSTextAttachment()
                    imageAttachment.image = UIImage(systemName: "checkmark.circle")
                    
                    let fullString = NSMutableAttributedString(string: "")
                    fullString.append(NSAttributedString(attachment: imageAttachment))
                    
                    let alert = UIAlertController(title: "", message: "You caught up all the news updates.", preferredStyle: .alert)
                    alert.setValue(fullString, forKey: "attributedTitle")
                    
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
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
                LogManager.e("Optional variable contains nil.")
                return
            }
            newArticle.imageName = key+imageFormat
            fileSystemManager.store(image: uiImage, forImageName: key+imageFormat, imageFormat: imageFormat)
            LogManager.i("News article is saved.")
        } else {
            fetchSavedArticle = coreDataManager.fetchSavedArticle(urlLink: (articles?[row].url)!)
            if let _imageName = fetchSavedArticle[0].imageName{
                fileSystemManager.deleteImage(forImageName: _imageName)
            }
            coreDataManager.deleteArticle(articleInfo: fetchSavedArticle[0])
            LogManager.i("News article is unsaved.")
        }
        coreDataManager.saveArticle()
    }
}



