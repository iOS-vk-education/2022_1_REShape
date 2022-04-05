//
//  DietScreenPresenter.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

final class DietScreenPresenter {
	weak var view: DietScreenViewInput?
    weak var moduleOutput: DietScreenModuleOutput?
    
	private let router: DietScreenRouterInput
	private let interactor: DietScreenInteractorInput
    
    var disclosureMeals: [IndexPath: Meals] = [:]
    
    init(router: DietScreenRouterInput, interactor: DietScreenInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension DietScreenPresenter: DietScreenModuleInput {
}

extension DietScreenPresenter: DietScreenViewOutput {
    func checkedMeal(atPosition position: Int, forMeal celltype: MealsType, inDay day: Int) {
        var mealString: String
        switch celltype {
        case .breakfast:
            mealString = "Meal for breakfast"
        case .lunch:
            mealString = "Meal for lunch"
        case .dinner:
            mealString = "Meal for dinner"
        default:
            return
        }
        print("[DEBUG] \(mealString) checked at \(day) day in \(position) position")
    }
    
    func uncheckedMeal(atPosition position: Int, forMeal celltype: MealsType, inDay day: Int) {
        var mealString: String
        switch celltype {
        case .breakfast:
            mealString = "Meal for breakfast"
        case .lunch:
            mealString = "Meal for lunch"
        case .dinner:
            mealString = "Meal for dinner"
        default:
            return
        }
        print("[DEBUG] \(mealString) unchecked at \(day) day in \(position) position")
    }
    
    func needMealList(day: Int, mealtype: MealsType) {
        var mealString: String
        switch mealtype {
        case .breakfast:
            mealString = "Breakfast"
        case .lunch:
            mealString = "Lunch"
        case .dinner:
            mealString = "Dinner"
        default:
            return
        }
        print("[DEBUG] \(mealString) clicked at \(day)")
        let meal: [Meals] = [Meals(mealName: "first", calories: 400, check: true), Meals(mealName: "second", calories: 300)]
        view?.setMealList(meal, day: day, celltype: mealtype)
    }
    
    func getNumOfDay() -> Int {
        return 10
    }
    
}

extension DietScreenPresenter: DietScreenInteractorOutput {
}
