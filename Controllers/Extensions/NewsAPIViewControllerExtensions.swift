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

    func didFailErrorDueToNetwork(_ networkError: Error) {
        let alert = UIAlertController(title: "Error!!.", message: "\(networkError.localizedDescription)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func didFailErrorDueToDecoding(_ decodingError: Error) {
        let alert = UIAlertController(title: "Error in Decoding!!.", message: "\(decodingError.localizedDescription)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func fetchAndUpdateNews(_ apiNewsModel: APINewsModel) {
        self.apiNewsModel = apiNewsModel
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
    func fetchCategoryNews(_ category: String) {
        page = 1
        invalidArticlesCount = 0
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
        if let urlToImage = articles?[indexPath.row].urlToImage{
            self.imageCount += 1
        apiNewsManager.apiRequest(urlToImage: urlToImage, count: imageCount) { data, response, error, count in
             var imageType = ""
                    if let _data = data{
                        print(urlToImage)
                        print(_data.format())
                        DispatchQueue.main.async {
                            let imageFetched: UIImage = UIImage(data: _data) ?? UIImage(named: Constants.noImage)!
                            cell.newsImage.image = imageFetched
                         //   self.imagesDictionary[(self.articles?[indexPath.row].url)!] = imageFetched
                            if (_data.format() == .jpg){
                                imageType = ".jpg"
                            } else if (_data.format() == .png){
                                imageType = ".png"
                            }
                            let imageProperty = ImageProperty(data: _data, key: count, imageFormat: imageType)
                            self.imagesDictionary[(self.articles?[indexPath.row].url)!] = imageProperty
                        }
                    }
                 else{
                    DispatchQueue.main.async {
                        cell.newsImage.image = UIImage(named: Constants.noImage)
                        let imageData = UIImage(named: Constants.noImage)?.pngData()
                        guard let _imageData = imageData else {return}
                        let imageProperty = ImageProperty(data: _imageData, key: count, imageFormat: ".png")
                        self.imagesDictionary[(self.articles?[indexPath.row].url)!] = imageProperty
//                        self.imagesDictionary[(self.articles?[indexPath.row].url)!] = UIImage(named: Constants.noImage)
                    }
                }
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
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let _articles = articles{
            if (indexPath.row == _articles.count-1){
                print("Articles fetched page wise: \(_articles.count)")
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
    func clicked(_ row: Int, _ buttonState: String) {
        if (buttonState == "save"){
            let newArticle = ArticleInfo(context: context)
            newArticle.newsTitle = articles?[row].title
            newArticle.newsDescritption = articles?[row].description
            newArticle.sourceName = articles?[row].source.name
            newArticle.urlLink = articles?[row].url
            newArticle.newsImage = imagesDictionary[(articles?[row].url)!]?.data
//            if let _imageData = newArticle.newsImage{
//                let uiImage = UIImage(data: newArticle.newsImage!)
//                print(_imageData.format())
//                if (_imageData.format() == .jpg){
//                    fileSystemManager.store(image: uiImage!, forKey: 1, imageFormat: ".jpg")
//                } else if (_imageData.format() == .png){
//                    fileSystemManager.store(image: uiImage!, forKey: 1, imageFormat: ".png")
//                }
//            }
            guard let uiImage = UIImage(data: imagesDictionary[(articles?[row].url)!]!.data), let imageFormat = imagesDictionary[(articles?[row].url)!]?.imageFormat, let key = imagesDictionary[(articles?[row].url)!]?.key else { return }
                fileSystemManager.store(image: uiImage, forKey: key, imageFormat: imageFormat)
        } else {
            fetchSavedArticle = coreDataManager.fetchSavedArticle(urlLink: (articles?[row].url)!)
            coreDataManager.deleteArticle(articleInfo: fetchSavedArticle[0])
        }
        coreDataManager.saveArticle()
    }
}



