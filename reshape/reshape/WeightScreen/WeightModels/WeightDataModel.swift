//
//  WeightDataModel.swift
//  reshape
//
//  Created by Иван Фомин on 17.04.2022.
//

import Foundation

class WeightDataModel {
    private var modelDate: String
    private var modelTime: String
    private var modelWeight: Int
    
    init() {
        self.modelDate = ""
        self.modelTime = ""
        self.modelWeight = 0
    }
    
    init(date: String, time: String, weight: Int) {
        self.modelDate = date
        self.modelTime = time
        self.modelWeight = weight
    }
    
    init(date: Date, weight: Int) {
        self.modelDate = WeightDataModel.convertToDateString(fromDate: date)
        self.modelTime = WeightDataModel.convertToTimeString(fromDate: date)
        self.modelWeight = weight
    }
    
    static func convertToDateString(fromDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "d MMMM yyyy'г'"
        
        return dateFormatter.string(from: date)
    }
    
    static func convertToTimeString(fromDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
    static func convertToDate(fromDate dateString: String, fromTime timeString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "d MMMM yyyy'г' HH:mm"
        
        return dateFormatter.date(from: "\(dateString) \(timeString)") ?? Date()
    }
}

extension WeightDataModel {
    func getDate() -> Date {
        return WeightDataModel.convertToDate(fromDate: self.modelDate, fromTime: self.modelTime)
    }
    
    func getDateString() -> String {
        return modelDate
    }
    
    func getTimeString() -> String {
        return modelTime
    }
    
    func getWeight() -> Int {
        return modelWeight
    }
}
