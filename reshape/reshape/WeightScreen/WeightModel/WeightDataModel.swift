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
        self.modelDate = date.dateString()
        self.modelTime = date.timeString()
        self.modelWeight = weight
    }
}

// Опреаторы сравнения
extension WeightDataModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(modelWeight)
    }
    
    static func ==(left: WeightDataModel, right: WeightDataModel) -> Bool {
        if left.modelTime != right.modelTime {
            return false
        }
        if left.modelDate != right.modelDate {
            return false
        }
        if left.modelWeight != right.modelWeight {
            return false
        }
        return true
    }
}

// Геттеры
extension WeightDataModel {
    func getDate() -> Date {
        return Date(fromDate: self.modelDate, fromTime: self.modelTime)
    }
    
    func getDateString() -> String {
        return modelDate
    }
    
    func getShortDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "d MMMM yyyy'г'"
        
        guard let date = dateFormatter.date(from: "\(modelDate)") else {
            return "nil"
        }
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: date)
    }
    
    func getTimeString() -> String {
        return modelTime
    }
    
    func getWeight() -> Int {
        return modelWeight
    }
}
