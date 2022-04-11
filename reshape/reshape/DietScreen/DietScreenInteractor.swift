//
//  DietScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

final class DietScreenInteractor {
	weak var output: DietScreenInteractorOutput?
}

extension DietScreenInteractor: DietScreenInteractorInput {
    func setMealState(_ state: Bool, atPosition position: Int, forMeal celltype: MealsType, inDay day: Int) {
        print("[DEBUG] New state of \(celltype.text) transmit at \(day) day in \(position) position")
    }
    
    func getNumOfDays() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let days = 10
            self.output?.setNumOfDays(days)
        })
    }
    
    func getMealList(toDay day: Int, toMeal mealtype: MealsType) {
        print("[DEBUG] Data from \(mealtype.text) need to get at \(day) day")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let meal: [Meals] = [Meals(mealName: "first", calories: 400, check: true), Meals(mealName: "second", calories: 300)]
            self.output?.setMealList(meal, day: day, celltype: mealtype)
        })
    }
    
}
