//
//  fetchNews.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 15/07/23.
//

import Foundation
import UIKit

protocol FetchNews{
    func fetchAndUpdateNews (_ apiNewsModel: APINewsModel)
    func didFailErrorDueToNetwork(_ networkError: Error)
    func didFailErrorDueToDecoding(_ decodingError: Error)
}
