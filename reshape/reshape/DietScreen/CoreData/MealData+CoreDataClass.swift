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
    convenience init(id: Int, nameString name: String, calories cal: Double, state: Bool, day: Int, diet: MealsType, context: NSManagedObjectContext) {
        self.init(context: context)
        self.setData(toID: id, toName: name, toCalories: cal, toState: state, toDay: day, toDiet: diet)
    }
    
    func setData(toID id: Int, toName name: String, toCalories cal: Double, toState state: Bool, toDay day: Int, toDiet diet: MealsType) {
        self.modelID = Int32(id)
        self.modelName = name
        self.modelCalories = cal
        self.modelState = state
        self.modelDay = Int32(day)
        self.modelDiet = Int16(diet.int)
    }
    
    func changeState(toState state: Bool) {
        self.modelState = state
    }
    
    func copyFrom(_ meal: MealData) {
        self.modelCalories = meal.modelCalories
        self.modelState = meal.modelState
        self.modelName = meal.modelName
    }
}
