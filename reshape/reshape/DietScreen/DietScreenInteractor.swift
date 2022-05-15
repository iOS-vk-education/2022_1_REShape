//
//  DietScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

final class DietScreenInteractor {
    private var cellData: [CellData] = []
	weak var output: DietScreenInteractorOutput?
    
    // Базы данных
    private let modelController: DietModelController
    private var firebaseModelController: DietFirebaseModelController
    
    init() {
        modelController = DietModelController()
        firebaseModelController = DietFirebaseModelController()
        uploadFromDatabase()
    }
    
    private func numOfDays() -> Int {
        return cellData.count/3
    }
    
    // Создание внутреннего кэша данных по каждому приёму пищи
    private func createCellData(withNewDays newDays: UInt = 0) {
        let oldDays = numOfDays()
        if newDays < oldDays {
            for curSection in Int(newDays)...oldDays-1 {
                modelController.deleteCellData(in: [
                    cellData[cellIndex(forMeal: .breakfast, atSection: curSection)!],
                    cellData[cellIndex(forMeal: .lunch, atSection: curSection)!],
                    cellData[cellIndex(forMeal: .snack, atSection: curSection)!],
                    cellData[cellIndex(forMeal: .dinner, atSection: curSection)!]
                ])
            }
        } else if newDays > oldDays {
            for curSection in oldDays...Int(newDays)-1 {
                cellData.append(contentsOf: modelController.addCellData(toSection: curSection))
            }
        }
        saveDatabase()
        uploadFromDatabase()
    }
    
    // Загрузка данных из локальной БД
    private func uploadFromDatabase() {
        do {
            cellData = try modelController.getCellData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Получение позиции данных ячейки из внутреннего кэша
    private func cellIndex(forMeal meal: MealsType, atSection section: Int) -> Int? {
        return cellData.firstIndex(where: { $0.cellSection == section && $0.cellType == meal.int })
    }
    
    // Получение позиции блюда для ячейки из внутреннего кэша по ячейке
    private func mealIndex(forCellData cell: CellData, atID id: Int) -> Int? {
        return (cell.cellMeals?.allObjects as! [MealData]).firstIndex(where: { meal in
            return meal.modelID == id
        })
    }
    
    // Получение позиции блюда для ячейки из внутреннего кэша по ID и позиции в кэше
    private func mealIndex(forCellPosition position: Int, atID id: Int) -> Int? {
        let cell = cellData[position]
        return mealIndex(forCellData: cell, atID: id)
    }
    
    // Получение позиции блюда для ячейки из внутреннего кэша по приёму пищи, секции и ID
    private func mealIndex(forMeal meal: MealsType, atSection section: Int, atID id: Int) -> Int? {
        guard let cellDataIndex = cellIndex(forMeal: meal, atSection: section) else { return nil }
        return mealIndex(forCellPosition: cellDataIndex, atID: id)
    }
    
    private func deleteMeals(greaterThanID id: UInt, forMeal type: MealsType, inSection section: Int) {
        let oldNumOfMeals = self.getMealCount(forMeal: type, atSection: section)
        if id >= oldNumOfMeals { return }
        for mealID in Int(id)...oldNumOfMeals-1 {
            let cell = getCellData(forMeal: type, atSection: section)
            let mealData = getMealData(withID: mealID, forMeal: type, atSection: section)
            cell.removeFromCellMeals(mealData)
        }
        saveDatabase()
    }
}

// Firebase методы
extension DietScreenInteractor {
    // Запрос на получение данных из Firebase
    private func requestMealData(toDay day: Int, toMeal mealtype: MealsType) {
        print("[DEBUG] Data from \(mealtype.text) need to get at \(day) day")
        
        firebaseModelController.getMeals(forDay: day, atMeal: mealtype.engText) {
            [weak self] numOfMeals, error in guard (error == nil) else { return }
            
            // Запрос на загрузку индивидуальных параметров
            self?.firebaseModelController.loadIndividualInfo()

            // Удаление лишних блюд
            self?.deleteMeals(greaterThanID: numOfMeals, forMeal: mealtype, inSection: day - 1)
            if numOfMeals == 0 { return }
            
            // Обновление блюд
            let cell = self!.getCellData(forMeal: mealtype, atSection: day - 1)
            for mealNumber in 1...numOfMeals {
                let id = mealNumber - 1
                let name = self?.firebaseModelController.mealName(forID: mealNumber) ?? ""
                let calories = self?.firebaseModelController.mealCalories(forID: mealNumber) ?? 0
                let state = self?.firebaseModelController.mealState(forDay: day, atMeal: mealtype.engText, forID: mealNumber) ?? false
                guard let mealDataIndex = self?.mealIndex(forCellData: cell, atID: Int(id)) else {
                    cell.addMealData(withID: id, withName: name, withCal: calories, withState: state)
                    continue
                }
                cell.updateMealData(atIndex: mealDataIndex, withID: id, newName: name, newCal: calories, newState: state)
                }
            self?.saveDatabase()
            self?.output?.updateMealData(forMeal: cell.type(), atSection: cell.section())
        }
    }
    
    // Обработка изменения состояния блюда TODO
    func changeMealState(toState state: Bool, withID id: Int, forMeal meal: MealsType, atSection section: Int) {
        print("[DEBUG] New state of \(meal.text) transmit at \(section + 1) day in \(id) position")
        let mealData = getMealData(withID: id, forMeal: meal, atSection: section)
        firebaseModelController.newMealState(state, forDay: section + 1, forMeal: meal.engText, forID: id + 1, withCalories: mealData.modelCalories) {
            [weak self] error in guard (error == nil) else { return }
            mealData.changeState(toState: state)
            self?.saveDatabase()
            self?.output?.updateMealData(forMeal: meal, atSection: section)
        }
    }
    
    // Запрос на получение данных
    func getDatabase() {
        print("[DEBUG] Need get num of days")
        output?.updateNumOfDays(numOfDays())
        firebaseModelController.daysCount {
            [weak self] days, error in guard (error == nil) else { return }
            self?.createCellData(withNewDays: days)
            self?.output?.updateNumOfDays(Int(days))
        }
    }
}

// Внешние запросы
extension DietScreenInteractor: DietScreenInteractorInput {
    // Сохранение данных
    func saveDatabase() {
        modelController.saveContext()
    }
    
    // Получение данных о блюде
    func getMealData(withID id: Int, forMeal meal: MealsType, atSection section: Int) -> MealData {
        let cell = getCellData(forMeal: meal, atSection: section)
        guard let mealDataIndex = self.mealIndex(forCellData: cell, atID: id) else {
            fatalError("[ERROR] Can't find meal index for mealID: \(id)")
        }
        return cell.cellMeals?.allObjects[mealDataIndex] as! MealData
    }
    
    // Получение данных о ячейки
    func getCellData(forMeal meal: MealsType, atSection section: Int) -> CellData {
        guard let cellDataIndex = self.cellIndex(forMeal: meal, atSection: section) else {
            fatalError("[ERROR] Can't find element at \(section) section for \(meal.engText)")
        }
        return cellData[cellDataIndex]
    }
    
    // Получение числа блюд для каждой ячейки
    func getMealCount(forMeal meal: MealsType, atSection section: Int) -> Int {
        let data = getCellData(forMeal: meal, atSection: section)
        return data.cellMeals?.count ?? 0
    }
    
    // Обработка изменения состояния раскрывающейся ячейки
    func changeDisclosure(toState state: DisclosureState, forMeal meal: MealsType, atSection section: Int) {
        let cell = getCellData(forMeal: meal, atSection: section)
        cell.cellDisclosure = state.boolType
        
        // Запрос на сервер если ячейка открыта
        if state == .disclosure {
            self.requestMealData(toDay: section + 1, toMeal: meal)
        }
    }
}
