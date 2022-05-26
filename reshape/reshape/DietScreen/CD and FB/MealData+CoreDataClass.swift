//
//  MealData+CoreDataClass.swift
//  reshape
//
//  Created by Иван Фомин on 26.04.2022.
//
//

import Foundation
import CoreData

@objc(MealData)
public class MealData: NSManagedObject {
    convenience init(id: Int, nameString name: String, calories cal: Double, state: Bool, toCell cell: CellData, context: NSManagedObjectContext) {
        self.init(context: context)
        self.setData(toID: id, toName: name, toCalories: cal, toState: state)
        self.modelCell = cell
    }
    
    func setData(toID id: Int, toName name: String, toCalories cal: Double, toState state: Bool) {
        self.modelID = Int32(id)
        self.modelName = name
        self.modelCalories = cal
        self.modelState = state
    }
    
    func changeState(toState state: Bool) {
        self.modelState = state
    }
}
