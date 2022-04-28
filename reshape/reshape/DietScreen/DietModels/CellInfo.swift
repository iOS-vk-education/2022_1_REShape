//
//  DietEnums.swift
//  reshape
//
//  Created by Иван Фомин on 11.04.2022.
//

// Структура хранения ячейки базы данных
class CellInfo {
    var section: Int
    var cellType: MealsType
    var disclosureState: DisclosureState
    var meals: [MealData]
    
    init(_ sec: Int, initType: MealsType) {
        section = sec
        cellType = initType
        disclosureState = .closure
        meals = []
    }
    
    func updateMeals(to meals: [MealData]) {
        self.meals = meals
    }
    
    func addMeal(to meal: MealData) {
        self.meals.append(meal)
    }
    
    func changeDisclosure(toState state: DisclosureState) {
        self.disclosureState = state
    }
}
