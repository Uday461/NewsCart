//
//  Constants.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 18/07/23.
//

import Foundation
struct Constants{
   // static let apiForFetchingNews = "https://newsapi.org/v2/top-headlines?country=in&apiKey="
    
    //static let apiForFetchingNews = "https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com&apiKey="
    static let businessNewsApiQuery = "&category=business"
    static let healthNewsApiQuery = "&category=health"
    static let scienceNewsApiQuery = "&category=science"
    static let entertainmentNewsApiQuery = "&category=entertainment"
    static let technologyNewsApiQuery = "&category=technology"
    static let pageSize = 5
}
