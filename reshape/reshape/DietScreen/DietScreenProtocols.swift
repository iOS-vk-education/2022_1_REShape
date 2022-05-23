//
//  DietScreenProtocols.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation
import UIKit

protocol DietScreenModuleInput {
	var moduleOutput: DietScreenModuleOutput? { get }
}

protocol DietScreenModuleOutput: AnyObject {
}

// Команды управляющие вьюхой
protocol DietScreenViewInput: AnyObject {
    // Управление таблицей
    func showCells(for indexPaths: [IndexPath])
    func hideCells(for indexPaths: [IndexPath])
    func reloadTableView()
    func reloadTableRows(atIndex indexPaths: [IndexPath], animation: UITableView.RowAnimation)
}

protocol DietScreenViewOutput: AnyObject {
    // Запросы на обновление числа дней
    func requestData()
    
    // Запрос на сохранение в локальную БД
    func saveData()
    
    // Геттеры
    func getCurrentDay() -> Int
    func getDay(for section: Int) -> Int
    
    func getNumOfDay() -> Int
    func getNumOfRows(inSection section: Int) -> Int
    
    func getCellType(from indexPath: IndexPath) -> MealsType
    func getCellDisclosure(forMeal meal: MealsType, atSection section: Int) -> DisclosureState
    
    func getMealState(forMeal meal: MealsType, atIndex indexPath: IndexPath) -> Bool
    func getMealName(forMeal meal: MealsType, atIndex indexPath: IndexPath) -> String
    func getMealCalories(forMeal meal: MealsType, atIndex indexPath: IndexPath) -> Double
    
    // Обработчики нажатий на ячейки
    func clickedDiet(_ state: DisclosureState, mealType celltype: MealsType, inSection section: Int)
    func clickedMeal(forMeal celltype: MealsType, atIndex indexPath: IndexPath)
    
    // Поиск
    func searchMeal(forString searchText: String)
    func searchEnd()
}

protocol DietScreenInteractorInput: AnyObject {
    // Запросы от презентера
    func getDatabase()
    func saveDatabase()
    
    // Геттеры
    func getCurrentDay() -> Int
    func getCellData(forMeal meal: MealsType, atSection section: Int) -> CellData
    func getMealData(withID id: Int, forMeal meal: MealsType, atSection section: Int) -> MealData
    func getMealCount(forMeal meal: MealsType, atSection section: Int) -> Int
    
    // Изменение состояния базы данных
    func changeDisclosure(toState state: DisclosureState, forMeal meal: MealsType, atSection section: Int)
    func changeMealState(withID id: Int, forMeal meal: MealsType, atSection section: Int)
    
    // Поиск
    func findMeal(forString text: String) -> [SearchStruct]
}

protocol DietScreenInteractorOutput: AnyObject {
    // Ответы на запросы презентера или интерактора
    func updateMealData(forMeal meal: MealsType, atSection section: Int)
    func updateNumOfDays(_ days: Int)
}

protocol DietScreenRouterInput: AnyObject {
}
