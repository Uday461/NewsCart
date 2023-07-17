//
//  fetchNews.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 15/07/23.
//

import Foundation
import UIKit

protocol fetchNews{
    func fetchAndUpdateNews (_ articlesArray: [ArticleData])
    func didFailError(error: Error)
    func fetchImagesToNews(_ imagesArray: [UIImage])
}
