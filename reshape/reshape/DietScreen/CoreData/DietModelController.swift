//
//  DietDataController.swift
//  reshape
//
//  Created by Иван Фомин on 27.04.2022.
//

import Foundation
import CoreData

class DietModelController: AbstractModelController {
    init() {
        super.init(databaseName: "DietModel", completionClosure: {})
    }
    
    // Очистка базы данных
    func flushData() {
        do {
            let fetchRequest = MealData.fetchRequest()
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
