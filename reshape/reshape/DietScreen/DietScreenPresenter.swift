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
    
    func needMealList(day: Int, mealtype: MealsType) {
        var mealString: String
        switch mealtype {
        case .breakfast:
            mealString = "Breakfast"
        case .lunch:
            mealString = "Lunch"
        case .dinner:
            mealString = "Dinner"
        case .none:
            mealString = "None"
        case .mealBreakfast:
            mealString = "Meal for breakfast"
        case .mealLunch:
            mealString = "Meal for lunch"
        case .mealDinner:
            mealString = "Meal for dinner"
        }
        print("[DEBUG] \(mealString) clicked at \(day)")
        let meal: [Meals] = [Meals(name: "new", cal: 500), Meals(name: "second", cal: 300)]
        view?.setMealList(meal, day: day, mealtype: mealtype)
    }
    
    func getNumOfDay() -> Int {
        return 10
    }
    
}

extension DietScreenPresenter: DietScreenInteractorOutput {
}
