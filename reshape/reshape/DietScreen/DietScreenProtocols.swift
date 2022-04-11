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
    func setMealList(_ meals: [Meals], day: Int, celltype: MealsType)
}

protocol DietScreenModuleOutput: AnyObject {
}

protocol DietScreenViewInput: AnyObject {
    func showCells(for indexPaths: [IndexPath])
    func hideCells(for indexPaths: [IndexPath])
}

protocol DietScreenViewOutput: AnyObject {
    // Запрос на получение данных
    func initCellData()
    func updateMealList(day: Int, mealtype: MealsType)
    
    // Геттеры
    func getNumOfDay() -> Int
    func getMealType(from indexPath: IndexPath) -> MealsType
    func getCellData(forMeal meal: MealsType, atSection section: Int) -> CellInfo
    func getCellIndex(forMeal meal: MealsType, atSection section: Int) -> Int
    func getNumOfRows(inSection section: Int) -> Int
    
    // Обработчики нажатий
    func checkedDiet(mealType celltype: MealsType, inSection section: Int)
    func uncheckedDiet(mealType celltype: MealsType, inSection section: Int)
    func checkedMeal(atPosition position: Int, forMeal celltype: MealsType, inSection section: Int)
    func uncheckedMeal(atPosition position: Int, forMeal celltype: MealsType, inSection section: Int)
}

protocol DietScreenInteractorInput: AnyObject {
}

protocol DietScreenInteractorOutput: AnyObject {
}

protocol DietScreenRouterInput: AnyObject {
}
