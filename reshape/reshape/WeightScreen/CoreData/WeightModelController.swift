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
