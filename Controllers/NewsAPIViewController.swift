//
//  ViewController.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 14/07/23.
//

import UIKit
import SafariServices
import CoreData

class NewsAPIViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var apiNewsModel: APINewsModel?
    var articles: [Article]?
    var page = 1
    var apiNewsManager = APINewsManager()
    var header = HeaderView(frame: .zero)
    var invalidArticlesCount = 0
    var coreDataManager = CoreDataManager()
    var fetchSavedArticle = [ArticleInfo]()
    var imagesDictionary: [String:UIImage] = [:]

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        // Do any additional setup after loading the view.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        header.fetchCategoryNewsDelegate = self
        apiNewsManager.fetchNewsDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupTableHeaderView()
        apiNewsManager.fetchNews(urlString: Constants.apiForFetchingNews,page: page, pageSize: Constants.pageSize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(#function)
        tableView.reloadData()
    }
    
    
    //MARK: - SetUp HeaderView Methods
    
    private func setupTableHeaderView(){
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


//MARK: - FetchNewsProtocol Methods

extension NewsAPIViewController: FetchNews{
    func didFailErrorDueToNetwork(_ networkError: Error) {
        let alert = UIAlertController(title: "Network Error!!.", message: "Please check your internet connection.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func didFailErrorDueToDecoding(_ decodingError: Error) {
        print("Erro in JSON decoding: \(decodingError)")
    }
    
    func fetchAndUpdateNews(_ apiNewsModel: APINewsModel) {
        self.apiNewsModel = apiNewsModel
        if (page == 1){
            self.articles = apiNewsManager.validArticlesList(articles: apiNewsModel.articles)
            invalidArticlesCount = invalidArticlesCount + (apiNewsModel.articles.count - (articles?.count ?? 0))
            print("Invalid Articles Count:\(invalidArticlesCount)")
        } else{
            if let _validArticles = apiNewsManager.validArticlesList(articles: apiNewsModel.articles){
                self.articles?.append(contentsOf: _validArticles)
                invalidArticlesCount = invalidArticlesCount + (apiNewsModel.articles.count - (_validArticles.count))
                print("Invalid Articles Count:\(invalidArticlesCount)")
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
//MARK: - FetchCategoryNews Methods
extension NewsAPIViewController: FetchCategoryNews{
    func fetchSavedArticles() {
        var articlesPersisted:[ArticleInfo] = []
        let request: NSFetchRequest<ArticleInfo> = ArticleInfo.fetchRequest()
        do{
            articlesPersisted = try context.fetch(request)
        }catch{
            print("Error in retrieving data from CoreData: \(error)")
        }
        if (articlesPersisted.count == 0){
            performSegue(withIdentifier: "goToEmptyVC", sender: self)
        } else{
            performSegue(withIdentifier: "goToSavedArticlesVC", sender: self)
        }
    }
    
    func fetchHealthNews() {
        apiNewsManager.fetchNews(urlString: "\(Constants.apiForFetchingNews)\(Constants.healthNewsApiQuery)",page: 1, pageSize: 7)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchScienceNews() {
        apiNewsManager.fetchNews(urlString: "\(Constants.apiForFetchingNews)\(Constants.scienceNewsApiQuery)",page: 1, pageSize: 7)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchEntertainmentNews() {
        apiNewsManager.fetchNews(urlString: "\(Constants.apiForFetchingNews)\(Constants.entertainmentNewsApiQuery)",page: 1, pageSize: 7)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchTechnologyNews() {
        apiNewsManager.fetchNews(urlString: "\(Constants.apiForFetchingNews)\(Constants.technologyNewsApiQuery)",page: 1, pageSize: 7)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchBusinessNews() {
        apiNewsManager.fetchNews(urlString: "\(Constants.apiForFetchingNews)\(Constants.businessNewsApiQuery)",page: 1, pageSize: 7)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


//MARK: - UITableViewDataSource Methods

extension NewsAPIViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! CustomNewsCell
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
            let url = URL(string: urlToImage)
            let session = URLSession(configuration: .default)
            if let tempUrl = url {
                let task = session.dataTask(with: tempUrl){ Data, Response, Error in
                    if let error = Error{
                        print("Error in Image downloading: \(error)")
                        return
                    } else if let data = Data{
                        DispatchQueue.main.async {
                            let imageFetched: UIImage = UIImage(data: data) ?? UIImage(named: "no-image-icon")!
                            cell.newsImage.image = imageFetched
                         //   self.imagesArray.append(imageFetched)
                            self.imagesDictionary[(self.articles?[indexPath.row].url)!] = imageFetched
                        }
                    }
                }
                task.resume()
            } else {
                DispatchQueue.main.async {
                    cell.newsImage.image = UIImage(named: "no-image-icon")
                    self.imagesDictionary[(self.articles?[indexPath.row].url)!] = UIImage(named: "no-image-icon")
                    
                }
            }
        } else{
            DispatchQueue.main.async {
                cell.newsImage.image = UIImage(named: "no-image-icon")
                self.imagesDictionary[(self.articles?[indexPath.row].url)!] = UIImage(named: "no-image-icon")
            }
        }
        
        return cell
    }
    
}

//MARK: - ClickDelegate Methods

extension NewsAPIViewController: ClickDelegate{
    func clicked(_ row: Int, _ buttonState: String) {
        if (buttonState == "save"){
            let newArticle = ArticleInfo(context: context)
            newArticle.newsTitle = articles?[row].title
            newArticle.newsDescritption = articles?[row].description
            newArticle.sourceName = articles?[row].source.name
            newArticle.urlLink = articles?[row].url
            newArticle.newsImage = imagesDictionary[(articles?[row].url)!]?.pngData()
        } else {
            fetchSavedArticle = coreDataManager.fetchSavedArticle(urlLink: (articles?[row].url)!)
            context.delete(fetchSavedArticle[0])
        }
        do{
            try context.save()
        }catch{
            print("Error saving data into context: \(error)")
        }
    }
}

//MARK: - UITableViewDelegate Methods

extension NewsAPIViewController:  UITableViewDelegate{
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
                    apiNewsManager.fetchNews(urlString: Constants.apiForFetchingNews, page: page, pageSize: Constants.pageSize)
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
    
}

