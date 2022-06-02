//
//  MealData+CoreDataProperties.swift
//  reshape
//
//  Created by Иван Фомин on 30.04.2022.
//
//

import Foundation
import CoreData


extension MealData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealData> {
        return NSFetchRequest<MealData>(entityName: "MealData")
    }

    @NSManaged public var modelCalories: Double
    @NSManaged public var modelID: Int32
    @NSManaged public var modelName: String?
    @NSManaged public var modelState: Bool
    @NSManaged public var modelCell: CellData?

}

extension MealData : Identifiable {

}
