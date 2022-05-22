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
    
    // Удаление компонент
    func deleteCellData(in cellData: [CellData]) {
        cellData.forEach() { cell in
            cell.deleteMeals(greaterThanID: 0)
            managedObjectContext.delete(cell)
        }
    }
    
    // Добавление новых компонент
    func addCellData(toSection section: Int) -> [CellData] {
        return [CellData(section: section, cellType: .breakfast, context: managedObjectContext),
                CellData(section: section, cellType: .lunch, context: managedObjectContext),
                CellData(section: section, cellType: .snack, context: managedObjectContext),
                CellData(section: section, cellType: .dinner, context: managedObjectContext)]
    }
    
    // Извлечение компонент
    func getCellData() throws -> [CellData] {
        let fetchRequest = CellData.fetchRequest()
        return try managedObjectContext.fetch(fetchRequest)
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
