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
    func setMealList(_ meals: [Meals], day: Int, mealtype: MealsType)
}

protocol DietScreenViewOutput: AnyObject {
    func needMealList(day: Int, mealtype: MealsType)
    func getNumOfDay() -> Int
}

protocol DietScreenInteractorInput: AnyObject {
}

protocol DietScreenInteractorOutput: AnyObject {
}

protocol DietScreenRouterInput: AnyObject {
}
