//
//  CellData+CoreDataProperties.swift
//  reshape
//
//  Created by Иван Фомин on 30.04.2022.
//
//

import Foundation
import CoreData


extension CellData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CellData> {
        return NSFetchRequest<CellData>(entityName: "CellData")
    }

    @NSManaged public var cellDisclosure: Bool
    @NSManaged public var cellSection: Int32
    @NSManaged public var cellType: Int32
    @NSManaged public var cellMeals: NSSet?

}

// MARK: Generated accessors for cellMeals
extension CellData {

    @objc(addCellMealsObject:)
    @NSManaged public func addToCellMeals(_ value: MealData)

    @objc(removeCellMealsObject:)
    @NSManaged public func removeFromCellMeals(_ value: MealData)

    @objc(addCellMeals:)
    @NSManaged public func addToCellMeals(_ values: NSSet)

    @objc(removeCellMeals:)
    @NSManaged public func removeFromCellMeals(_ values: NSSet)

}

extension CellData : Identifiable {

}
