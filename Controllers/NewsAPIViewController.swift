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
    var articlesArray: [ArticleData] = []
    var imagesArray: [UIImage] = []
    var apiNewsManager = APINewsManager()
    var header = HeaderView(frame: .zero)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        header.fetchCategoryNewsDelegate = self
        apiNewsManager.fetchNewsDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupTableHeaderView()
        fetchNewsAndUpdateUI()
    }
    
    func fetchNewsAndUpdateUI(){
        apiNewsManager.performRequestForNews(urlString: Constants.apiForFetchingNews)
        
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


//MARK: - fetchNewsProtocol Methods

extension NewsAPIViewController: fetchNews{
    
    func fetchAndUpdateNews(_ articlesArray: [ArticleData]) {
        self.articlesArray = articlesArray
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailError(error: Error) {
        let alert = UIAlertController(title: "Network Error!!.", message: "Please check your internet connection.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - fetchCategoryNews Methods

extension NewsAPIViewController: fetchCategoryNews{
    func fetchSavedArticles() {
        performSegue(withIdentifier: "goToSavedArticlesVC", sender: self)
    }
    
    func fetchHealthNews() {
        apiNewsManager.performRequestForNews(urlString: "\(Constants.apiForFetchingNews)\(Constants.healthNewsApiQuery)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchScienceNews() {
        apiNewsManager.performRequestForNews(urlString: "\(Constants.apiForFetchingNews)\(Constants.scienceNewsApiQuery)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchEntertainmentNews() {
        apiNewsManager.performRequestForNews(urlString: "\(Constants.apiForFetchingNews)\(Constants.entertainmentNewsApiQuery)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchTechnologyNews() {
        apiNewsManager.performRequestForNews(urlString: "\(Constants.apiForFetchingNews)\(Constants.technologyNewsApiQuery)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchBusinessNews() {
        apiNewsManager.performRequestForNews(urlString: "\(Constants.apiForFetchingNews)\(Constants.businessNewsApiQuery)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


//MARK: - UITableViewDataSource Methods

extension NewsAPIViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! CustomNewsCell
        cell.clickDelegate = self
        cell.cellIndex = indexPath
        if let title = articlesArray[indexPath.row].title{
            cell.newsTitle.text = title
        } else{
            cell.newsTitle.text = "No Title."
        }
        if let description = articlesArray[indexPath.row].description{
            cell.newsDescription.text = description
        } else{
            cell.newsDescription.text = "No Description."
        }
        if let source = articlesArray[indexPath.row].sourceName{
            cell.newsSource.text = source
        } else{
            cell.newsSource.text = "No Source."
        }
        if let urlToImage = articlesArray[indexPath.row].urlToImage{
            let url = URL(string: urlToImage)
            let session = URLSession(configuration: .default)
            if let tempUrl = url {
                let task = session.dataTask(with: tempUrl){ Data, Response, Error in
                    if let error = Error{
                        print("Error in Image downloading: \(error)")
                        return
                    } else if let data = Data{
                        DispatchQueue.main.async {
                            cell.newsImage.image = UIImage(data: data)
                            self.imagesArray.append(UIImage(data: data)!)
                        }
                    }
                }
                task.resume()
            } else {
                DispatchQueue.main.async {
                    cell.newsImage.image = UIImage(named: "no-image-icon")
                    self.imagesArray.append(UIImage(named: "no-image-icon")!)

                }
            }
        } else{
            DispatchQueue.main.async {
                cell.newsImage.image = UIImage(named: "no-image-icon")
                self.imagesArray.append(UIImage(named: "no-image-icon")!)
            }
        }
        
        return cell
    }
    
}

//MARK: - ClickDelegate Methods

extension NewsAPIViewController: ClickDelegate{
    func clicked(_ row: Int) {
        print("Row:\(row) data is saved")
        let newArticle = ArticleInfo(context: context)
        newArticle.newsTitle = articlesArray[row].title
        newArticle.newsDescritption = articlesArray[row].description
        newArticle.sourceName = articlesArray[row].sourceName
        newArticle.urlLink = articlesArray[row].url
        newArticle.newsImage = imagesArray[row].pngData()
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
        let newsUrl = articlesArray[indexPath.row].url
        guard let url = URL(string: newsUrl ?? "") else{
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
}

