//
//  DietScreenProtocols.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

protocol DietScreenModuleInput {
	var moduleOutput: DietScreenModuleOutput? { get }
}

protocol DietScreenModuleOutput: AnyObject {
}

protocol DietScreenViewInput: AnyObject {
    func setMealList(_ meals: [Meals], day: Int, celltype: MealsType)
}

protocol DietScreenViewOutput: AnyObject {
    func needMealList(day: Int, mealtype: MealsType)
    func getNumOfDay() -> Int
    func checkedMeal(atPosition position: Int, forMeal celltype: MealsType, inDay day: Int)
    func uncheckedMeal(atPosition position: Int, forMeal celltype: MealsType, inDay day: Int)
}

protocol DietScreenInteractorInput: AnyObject {
}

protocol DietScreenInteractorOutput: AnyObject {
}

protocol DietScreenRouterInput: AnyObject {
}
