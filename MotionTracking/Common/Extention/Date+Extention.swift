//
//  Date+Extention.swift
//  MotionTracking
//
//  Created by Karim Angama on 03/02/2022.
//

import Foundation

extension Date {
    
    enum DateFormat: String {
        case iso8601 = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    static let null: Date = {
        return Date(timeIntervalSince1970: 0)
    }()
    
    var nowDateIso8601: String {
        let format = DateFormatter()
        format.dateFormat = DateFormat.iso8601.rawValue
        return format.string(from: self)
    }
    
    var mediumDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
    
    static func string(date: String) -> Date {
        let format = DateFormatter()
        format.dateFormat = DateFormat.iso8601.rawValue
        return format.date(from: date) ?? Date.null
    }
    
}
