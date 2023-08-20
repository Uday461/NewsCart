//
//  Constants.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 18/07/23.
//

import Foundation
struct APIEndPoints{
    static let apiForFetchingNews = "https://newsapi.org/v2/top-headlines?country=in&apiKey=&pageSize=\(pageSize)&page="
    static let apiForFetchingCategoryNews = "https://newsapi.org/v2/top-headlines?country=in&apiKey=&pageSize=\(pageSize)&category="
    static let pageSize = 5
}
struct Constants{
    static let businessNewsApiQuery = "business"
    static let healthNewsApiQuery = "health"
    static let scienceNewsApiQuery = "science"
    static let entertainmentNewsApiQuery = "entertainment"
    static let technologyNewsApiQuery = "technology"
    static let sportsNewsApiQuery = "sports"
    static let noImage = "no-image-icon"
}

struct Identifiers{
    static let goToEmptyVC = "goToEmptyVC"
    static let goToSavedArticlesVC = "goToSavedArticlesVC"
    static let newsCell = "newsCell"
    static let articleDataCell = "articleDataCell"
    static let goToNewsVC = "goToNewsVC"
}
