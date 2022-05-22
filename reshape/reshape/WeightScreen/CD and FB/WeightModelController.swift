//
//  DataController.swift
//  reshape
//
//  Created by Иван Фомин on 22.04.2022.
//

import Foundation
import UIKit
import CoreData

class WeightModelController: AbstractModelController {
    init() {
        super.init(databaseName: "WeightModel", completionClosure: {})
    }
    
    // Извлечение компонент
    func getWeightData() throws -> [WeightModel] {
        let fetchRequest = WeightModel.fetchRequest()
        return try managedObjectContext.fetch(fetchRequest)
    }
    
    func setWeightData(forID id: Int, weightString weight: String, dateString date: String, timeString time: String) -> WeightModel {
        return WeightModel(id: id, dateString: date, timeString: time, weightString: weight, context: managedObjectContext)
    }
    
    func deleteWeightData(_ object: WeightModel) {
        managedObjectContext.delete(object)
    }
    
    // Очистка базы данных
    func flushData() {
        do {
            let fetchRequest = WeightModel.fetchRequest()
            let result = try managedObjectContext.fetch(fetchRequest)
            for model in result {
                managedObjectContext.delete(model)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        saveContext()
    }
}
