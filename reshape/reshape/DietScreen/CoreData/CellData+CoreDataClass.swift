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
    
    func mealData(atID id: Int) -> MealData? {
        return (self.cellMeals?.allObjects as! [MealData]).first(where: { meal in
            meal.modelID == id
        })
    }
    
    func mealCount() -> Int {
        return self.cellMeals?.count ?? 0
    }
    
    func deleteMeals(greaterThanID id: Int) {
        let oldNumOfMeals = self.mealCount()
        if id >= oldNumOfMeals { return }
        for mealID in id...oldNumOfMeals-1 {
            guard let mealData = self.mealData(atID: mealID) else {
                continue
            }
            self.removeFromCellMeals(mealData)
        }
    }
    
    func updateMealData(atIndex index: Int, withID id: UInt, newName name: String, newCal calories: Double, newState state: Bool) {
        (self.cellMeals?.allObjects[index] as! MealData).setData(
            toID: Int(id),
            toName: name,
            toCalories: calories,
            toState: state
        )
    }
    
    func addMealData(withID id: UInt, withName name: String, withCal calories: Double, withState state: Bool) {
        self.addToCellMeals(MealData(
            id: Int(id),
            nameString: name,
            calories: calories,
            state: state,
            toCell: self,
            context: self.managedObjectContext!)
        )
    }
}
