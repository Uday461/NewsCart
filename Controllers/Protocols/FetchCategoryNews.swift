//
//  fetchCategoryNews.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 17/07/23.
//

import Foundation

protocol FetchCategoryNews{
    func fetchSavedArticles()
    func fetchCategoryNews(_ category: String)
}
