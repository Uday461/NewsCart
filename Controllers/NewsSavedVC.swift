//
//  NewsSavedVC.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 18/07/23.
//

import UIKit
import CoreData

class NewsSavedVC: UIViewController{

   
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var articleArray = [ArticleInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 180
        tableView.register(UINib(nibName: "NoSavedArticleCell", bundle: nil), forCellReuseIdentifier: "NoSavedArticleCell")
        loadArticles()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        loadArticles()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func loadArticles(){
        let request: NSFetchRequest<ArticleInfo> = ArticleInfo.fetchRequest()
        do{
            articleArray = try context.fetch(request)
        }catch{
           print("Error in retrieving data from CoreData: \(error)")
        }
    }
    
}

//MARK: - UITableViewDataSource Methods

extension NewsSavedVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if articleArray.count == 0{
//            return 1
//        }
//        else {
//        }
        return articleArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if articleArray.count == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NoSavedArticleCell") as! NoSavedArticleCell
//            return cell
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleDataCell") as! CustomSavedNewsCell
            cell.titleLabel.text = articleArray[indexPath.row].newsTitle
            cell.descriptionLabel.text = articleArray[indexPath.row].newsDescritption
            if let source = articleArray[indexPath.row].sourceName{
            cell.sourceLabel.text = source
           } else {
            cell.sourceLabel.text = "No source."
           }
           let imageBinary = articleArray[indexPath.row].newsImage
           cell.newsImage.image = UIImage(data: imageBinary!)
           return cell
    }

}

//MARK: - UITableViewDelegate Methods

extension NewsSavedVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let count = articleArray.count
        if  (count == 0){
            return
        }
        performSegue(withIdentifier: "goToNewsVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let savedArticlesVC = segue.destination as! SavedArticleViewController
        let selectedRow = tableView.indexPathForSelectedRow!.row
        savedArticlesVC.indexPathRow = selectedRow
    }
}




