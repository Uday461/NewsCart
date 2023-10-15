//
//  DateUtils.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 14/10/23.
//

import Foundation
class DateUtils {
    static func dateInStringFormat(date: Date)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let dateInString = dateFormatter.string(from: date)
        return dateInString
    }
}
