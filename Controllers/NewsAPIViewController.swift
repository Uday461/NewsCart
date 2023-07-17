//
//  ViewController.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 14/07/23.
//

import UIKit
import SafariServices

class NewsAPIViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var articlesArray: [ArticleData] = []
    var imagesArray: [UIImage] = []
    var apiNewsManager = APINewsManager()
   // var headerView = HeaderView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     //   headerView.fetchCategoryNewsDelegate = self
        apiNewsManager.fetchNewsDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupTableHeaderView()
        fetchNewsAndUpdateUI()
    }
    
    func fetchNewsAndUpdateUI(){
        apiNewsManager.performRequestForNews(urlString: "https://newsapi.org/v2/top-headlines?country=in&apiKey=2fa323dfd66b46a6a3f16e37f6dca6a6")
    
    }
}

//MARK: - fetchNewsProtocol Methods

extension NewsAPIViewController: fetchNews{
    func fetchImagesToNews(_ imagesArray: [UIImage]) {
        self.imagesArray = imagesArray
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchAndUpdateNews(_ articlesArray: [ArticleData]) {
        self.articlesArray = articlesArray
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailError(error: Error) {
        let alert = UIAlertController(title: "Network Error!!.", message: "Please check your internet connection.", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - fetchCategoryNews Methods

//extension NewsAPIViewController: fetchCategoryNews{
//    func fetchBusinessNews() {
//        apiNewsManager.performRequestForNews(urlString: "https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=2fa323dfd66b46a6a3f16e37f6dca6a6")
//        tableView.reloadData()
//    }
//}



//MARK: - UITableViewDataSource Methods

extension NewsAPIViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! CustomNewsCell
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
        DispatchQueue.main.async {
            cell.newsImage.image = self.imagesArray[indexPath.row]
        }
        
        return cell
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

//MARK: - SetUp HeaderView Methods
    
    private func setupTableHeaderView(){
        let header = HeaderView(frame: .zero)
        let title = "Your daily news updates are here!.."
        var char = 0.0
        header.label.text = ""
    for letter in title{
        Timer.scheduledTimer(withTimeInterval: 0.1*char, repeats: false) { timer in
           header.label.text?.append(letter)
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






//        if let urlToImage = articlesArray[indexPath.row].urlToImage{
//            let url = URL(string: urlToImage)
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url!){ Data, Response, Error in
//                if let error = Error{
//                    print("Error in Image downloading: \(error)")
//                    return
//                } else if let data = Data{
//                    DispatchQueue.main.async {
//                        cell.newsImage.image = UIImage(data: data)
//                    }
//                }
//            }
//            task.resume()
//        } else{
//            cell.newsImage.image = UIImage(named: "no-image-icon")
//        }





//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50.0
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let string = "Categories"
//        return string
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
//        headerView.backgroundColor = .red
//        return headerView
//    }
