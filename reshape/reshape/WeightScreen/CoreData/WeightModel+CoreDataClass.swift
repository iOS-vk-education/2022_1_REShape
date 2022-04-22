//
//  WeightModel+CoreDataClass.swift
//  reshape
//
//  Created by Иван Фомин on 22.04.2022.
//
//

import Foundation
import CoreData

@objc(WeightModel)
public class WeightModel: NSManagedObject {
    convenience init(id: Int, dateString date: String, timeString time: String, weightString weight: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.setData(id: id, dateString: date, timeString: time, weightString: weight)
    }
    
    func setData(id: Int, date: Date, weightString weight: String) {
        self.modelID = Int32(id)
        self.modelDate = date.dateString()
        self.modelTime = date.timeString()
        self.modelWeight = weight
    }
    
    func setData(id: Int, dateString date: String, timeString time: String, weightString weight: String) {
        self.modelID = Int32(id)
        self.modelDate = date
        self.modelTime = time
        self.modelWeight = weight
    }
    
    func getDate() -> Date {
        return Date(fromDate: self.modelDate ?? "", fromTime: self.modelTime ?? "")
    }
    
    func getShortDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: self.getDate())
    }
    
    func getTimeString() -> String {
        return modelTime!
    }
    
    func getDateString() -> String {
        return modelDate!
    }
    
    func getWeight() -> String {
        return modelWeight!
    }
    
    func getID() -> Int {
        return Int(modelID)
    }
}
