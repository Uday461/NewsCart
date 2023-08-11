//
//  Constants.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 18/07/23.
//

import Foundation
struct Constants{
    static let apiForFetchingNews = "https://newsapi.org/v2/top-headlines?country=in&apiKey=2fa323dfd66b46a6a3f16e37f6dca6a6&pageSize=\(pageSize)&page="
    static let apiForFetchingCategoryNews = "https://newsapi.org/v2/top-headlines?country=in&apiKey=2fa323dfd66b46a6a3f16e37f6dca6a6&pageSize=\(pageSize)&category="
    static let businessNewsApiQuery = "business"
    static let healthNewsApiQuery = "health"
    static let scienceNewsApiQuery = "science"
    static let entertainmentNewsApiQuery = "entertainment"
    static let technologyNewsApiQuery = "technology"
    static let sportsNewsApiQuery = "sports"
    static let pageSize = 5
    static let goToEmptyVC = "goToEmptyVC"
    static let goToSavedArticlesVC = "goToSavedArticlesVC"
    static let newsCell = "newsCell"
    static let articleDataCell = "articleDataCell"
    static let goToNewsVC = "goToNewsVC"
    static let noImage = "no-image-icon"
}
