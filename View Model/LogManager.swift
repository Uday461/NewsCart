//
//  LogManager.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 17/08/23.
//

import Foundation
import OSLog
class LogManager{
    static var isLoggingEnabled = true
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    //Computed variable used for showing time and date of logging in specified format.
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    //Takes the sourcefilePath as argument and returns the ".swift" file from where the 'LogManager' is called.
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    //Method for printing log messages to console.
    static func log( _ object: Any,filename: String = #file,line: Int = #line,column: Int = #column,funcName: String = #function, logType: LogEvent){
        if LogManager.isLoggingEnabled {
            print("\(Date().toString()) \(logType.rawValue)[\(LogManager.sourceFileName(filePath: filename))]: Line: \(line) Col:\(column) \(funcName) -> \(object)")
        
        }
    }
    
}

extension Date {
    func toString() -> String {
        return LogManager.dateFormatter.string(from: self as Date)
    }
}
enum LogEvent: String {
    case error = "[❗️]"
    case info = "[ℹ️]"
}
