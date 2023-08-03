//
//  NewsSavedVC.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 30/07/23.
//

import Foundation
import UIKit

//MARK: - UITableViewDataSource Methods

extension NewsSavedVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleDataCell") as! CustomSavedNewsCell
        cell.titleLabel.text = articleArray[indexPath.row].newsTitle
        cell.descriptionLabel.text = articleArray[indexPath.row].newsDescritption
        if let source = articleArray[indexPath.row].sourceName{
            cell.sourceLabel.text = source
        } else {
            cell.sourceLabel.text = "No source."
        }
        let imageBinary = articleArray[indexPath.row].newsImage
        if let _imageBinary = imageBinary{
            cell.newsImage.image = UIImage(data: _imageBinary)
        } else {
            cell.newsImage.image = UIImage(named: "no-image-icon")
        }
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
