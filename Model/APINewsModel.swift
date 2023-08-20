//
//  APINewsModel.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 14/07/23.
//

import Foundation
//Data model for decoding json object.
struct APINewsModel: Codable{
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
}

struct Source: Codable{
    let name: String?
}
