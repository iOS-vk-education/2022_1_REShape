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
    var meals: [MealInfo]
    
    init(_ sec: Int, initType: MealsType) {
        section = sec
        cellType = initType
        disclosureState = .closure
        meals = []
    }
    
    func updateMeals(to meals: [MealInfo]) {
        self.meals = meals
    }
    
    func changeMealState(atIndex index: Int, toState state: Bool) {
        self.meals[index].checked = state
    }
    
    func changeDisclosure(toState state: DisclosureState) {
        self.disclosureState = state
    }
}
