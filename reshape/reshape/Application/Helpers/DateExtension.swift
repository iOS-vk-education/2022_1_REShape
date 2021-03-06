//
//  DateExtension.swift
//  reshape
//
//  Created by Иван Фомин on 20.04.2022.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        if lhs > rhs {
            return DateInterval(start: rhs, end: lhs).duration
        } else {
            return DateInterval(start: lhs, end: rhs).duration
        }
    }
    
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "d MMMM yyyy'г'"
    
        return dateFormatter.string(from: self)
    }

    func timeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "HH:mm"
    
        return dateFormatter.string(from: self)
    }

    init(fromDate dateString: String, fromTime timeString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "d MMMM yyyy'г' HH:mm"
        self = dateFormatter.date(from: "\(dateString) \(timeString)") ?? Date()
    }
}
