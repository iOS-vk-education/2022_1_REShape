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

// Команды управляющие вьюхой
protocol DietScreenViewInput: AnyObject {
    func showCells(for indexPaths: [IndexPath])
    func hideCells(for indexPaths: [IndexPath])
    func reloadTableView()
}

protocol DietScreenViewOutput: AnyObject {
    // Запросы на необходимость получение новых данных
    func updateNumOfDays()
    
    // Геттеры
    func getNumOfDay() -> Int
    func getMealType(from indexPath: IndexPath) -> MealsType
    func getCellData(forMeal meal: MealsType, atSection section: Int) -> CellInfo
    func getMealData(forMeal meal: MealsType, atIndex indexPath: IndexPath) -> Meals
    func getCellIndex(forMeal meal: MealsType, atSection section: Int) -> Int
    func getNumOfRows(inSection section: Int) -> Int
    
    // Обработчики нажатий на ячейки
    func checkedDiet(mealType celltype: MealsType, inSection section: Int)
    func uncheckedDiet(mealType celltype: MealsType, inSection section: Int)
    func checkedMeal(forMeal celltype: MealsType, atIndex indexPath: IndexPath)
    func uncheckedMeal(forMeal celltype: MealsType, atIndex indexPath: IndexPath)
}

protocol DietScreenInteractorInput: AnyObject {
    // Геттеры
    func getNumOfDays()
    func getMealList(toDay day: Int, toMeal mealtype: MealsType)
    
    // Запись в FireBase информации о состоянии блюда
    func setMealState(_ state: Bool, atPosition position: Int, forMeal celltype: MealsType, inDay day: Int)
}

protocol DietScreenInteractorOutput: AnyObject {
    func setMealList(_ meals: [Meals], day: Int, celltype: MealsType)
    func setNumOfDays(_ days: Int)
}

protocol DietScreenRouterInput: AnyObject {
}
