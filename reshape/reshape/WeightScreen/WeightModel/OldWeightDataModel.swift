//
//  OldWeightDataModel.swift
//  reshape
//
//  Created by Иван Фомин on 17.04.2022.
//

import Foundation

class OldWeightDataModel {
    private var modelDate: String
    private var modelTime: String
    private var modelWeight: String
    
    init() {
        self.modelDate = ""
        self.modelTime = ""
        self.modelWeight = ""
    }
    
    init(date: String, time: String, weight: String) {
        self.modelDate = date
        self.modelTime = time
        self.modelWeight = weight
    }
    
    init(date: Date, weight: String) {
        self.modelDate = date.dateString()
        self.modelTime = date.timeString()
        self.modelWeight = weight
    }
}

// Опреаторы сравнения
extension OldWeightDataModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(modelWeight)
        hasher.combine(modelTime)
        hasher.combine(modelDate)
    }

    static func ==(left: OldWeightDataModel, right: OldWeightDataModel) -> Bool {
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
extension OldWeightDataModel {
    func getDate() -> Date {
        return Date(fromDate: self.modelDate, fromTime: self.modelTime)
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
    
    func getDateString() -> String {
        return modelDate
    }
    
    func getWeight() -> String {
        return modelWeight
    }
}
