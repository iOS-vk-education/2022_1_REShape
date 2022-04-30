//
//  CellData+CoreDataClass.swift
//  reshape
//
//  Created by Иван Фомин on 30.04.2022.
//
//

import Foundation
import CoreData


public class CellData: NSManagedObject {
    convenience init(section sec: Int, cellType type: MealsType, context: NSManagedObjectContext) {
        self.init(context: context)
        cellSection = Int32(sec)
        cellType = Int32(type.int)
        cellDisclosure = false
        cellMeals = []
    }
    
    func type() -> MealsType {
        return MealsType(Int(cellType))
    }
    
    func section() -> Int {
        return Int(cellSection)
    }
}
