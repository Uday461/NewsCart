//
//  Constants.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 18/07/23.
//

import Foundation
struct APIEndPoints{
    static let apiForFetchingNews = "https://newsapi.org/v2/top-headlines?country=in&apiKey=\(Constants.apiKey)&pageSize=\(pageSize)&page="
    static let apiForFetchingCategoryNews = "https://newsapi.org/v2/top-headlines?country=in&apiKey=\(Constants.apiKey)&pageSize=\(pageSize)&category="
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
    static let appID = Bundle.main.infoDictionary?["APP_ID"] as! String
    static let appGroupID = "group.com.Uday.NewsCart.MoEngage"
    static let apiKey = Bundle.main.infoDictionary?["API_KEY"] as! String
    struct SelfHandledCardsConstants {
        static let basic = "basic"
        static let illustration = "illustration"
    }
    
    struct TableViewCellIdentifiers {
        static let cardsillustrationCell = "cardsillustrationCell"
        static let cardsBasicWithImageCell = "cardsBasicWithImageCell"
        static let cardsCell = "cardsCell"
    }
}

struct Identifiers{
    static let goToEmptyVC = "goToEmptyVC"
    static let goToSavedArticlesVC = "goToSavedArticlesVC"
    static let newsCell = "newsCell"
    static let articleDataCell = "articleDataCell"
    static let goToNewsVC = "goToNewsVC"
    static let headerView = "HeaderView"
    static let save = "save"
    static let unsave = "unsave"
    static let noSavedArticleCell = "NoSavedArticleCell"
    static let newsCart = "NewsCart"
    struct systemName{
        static let bookmarkfill = "bookmark.fill"
        static let bookmark = "bookmark"
    }
}
