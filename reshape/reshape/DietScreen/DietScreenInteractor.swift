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
    weak var firebaseController: DietFirebaseProtocol?
    
    // База данных
    private let modelController: DietModelController
    
    init() {
        modelController = DietModelController()
        uploadFromDatabase()
        firebaseController = nil
    }
    
    private func numOfDays() -> Int {
        return cellData.count/4
    }
    
    // Создание внутреннего кэша данных по каждому приёму пищи
    private func createCellData(withNewDays newDays: Int = 0) {
        let oldDays = numOfDays()
        // Удаление лишних дней
        if newDays < oldDays {
            for curSection in newDays...oldDays-1 {
                modelController.deleteCellData(in: [
                    cellData[cellIndex(forMeal: .breakfast, atSection: curSection)!],
                    cellData[cellIndex(forMeal: .lunch, atSection: curSection)!],
                    cellData[cellIndex(forMeal: .snack, atSection: curSection)!],
                    cellData[cellIndex(forMeal: .dinner, atSection: curSection)!]
                ])
            }
        
        // Добавление недостающих дней
        } else if newDays > oldDays {
            for curSection in oldDays...newDays-1 {
                let newCellData = modelController.addCellData(toSection: curSection)
                cellData.append(contentsOf: newCellData)
                for cell in newCellData {
                    self.extractMealData(fromSection: curSection, toMeal: MealsType(Int(cell.cellType)))
                }
            }
        }
        
        // Сохранение обновлений
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
    
    private func deleteMeals(greaterThanID id: Int, forMeal type: MealsType, inSection section: Int) {
        let oldNumOfMeals = self.getMealCount(forMeal: type, atSection: section)
        if id >= oldNumOfMeals { return }
        for mealID in id...oldNumOfMeals-1 {
            let cell = getCellData(forMeal: type, atSection: section)
            let mealData = getMealData(withID: mealID, forMeal: type, atSection: section)
            cell.removeFromCellMeals(mealData)
        }
        saveDatabase()
    }
    
    private func calculateCalories(forSection section: Int) -> Double {
        var calories: Double = 0
        cellData.forEach({ info in
            guard info.cellSection == section else { return }
            guard let mealsSet = (info.cellMeals as? Set<MealData>) else { return }
            for meal in mealsSet {
                if meal.modelState {
                    calories += meal.modelCalories
                }
            }
        })
        return calories
    }
    
    // Запрос на получение данных из Firebase
    private func extractMealData(fromSection section: Int, toMeal meal: MealsType) {
        // Получение числа блюд
        guard let mealCount = firebaseController?.getMealsCount(forDay: section + 1, forMeal: meal.engText) else {
            return
        }
            
        // Удаление лишних блюд
        deleteMeals(greaterThanID: mealCount, forMeal: meal, inSection: section)
        if mealCount == 0 { return }
        
        // Обновление блюд
        let cell = getCellData(forMeal: meal, atSection: section)
        for mealNumber in 1...mealCount {
            let newData = firebaseController!.getMeal(forID: mealNumber, forDay: section + 1, atMeal: meal.engText)
            let id = mealNumber - 1
            let name = newData.name
            let calories = newData.calories
            let state = newData.state
            guard let mealDataIndex = mealIndex(forCellData: cell, atID: id) else {
                cell.addMealData(withID: id, withName: name, withCal: calories, withState: state)
                continue
            }
            cell.updateMealData(atIndex: mealDataIndex, withID: id, newName: name, newCal: calories, newState: state)
        }
            
        // Сохранение изменений
        saveDatabase()
        output?.updateMealData(forMeal: cell.type(), atSection: cell.section())
    }
}

// Firebase методы
extension DietScreenInteractor {
    // Обработка изменения состояния раскрывающейся ячейки
    func changeDisclosure(toState state: DisclosureState, forMeal meal: MealsType, atSection section: Int) {
        let cell = getCellData(forMeal: meal, atSection: section)
        cell.cellDisclosure = state.boolType
        
        // Запрос на сервер если ячейка открыта
        if state == .disclosure {
            print("[DEBUG] Data from \(meal.text) need to get at \(section + 1) day")
            // Запрос на загрузку индивидуальных параметров
            firebaseController?.loadIndividualInfo { _ in return }
            firebaseController?.loadCommonInfo { [weak self] error in
                // Блок проверок
                guard (error == nil) else { return }
                guard (self != nil) else { return }
                
                // Извлечение данных
                self!.extractMealData(fromSection: section, toMeal: meal)
            }
        }
    }
    
    // Обработка изменения состояния блюда TODO
    func changeMealState(withID id: Int, forMeal meal: MealsType, atSection section: Int) {
        // Проверка на день
        if firebaseController?.getCurrentDay() != section {
            return
        }
        let mealData = getMealData(withID: id, forMeal: meal, atSection: section)
        
        // Вычисление новых параметров для отправк
        let state = !mealData.modelState
        var cal = calculateCalories(forSection: section)
        cal += state ? mealData.modelCalories : -mealData.modelCalories
        
        // Отправка данных
        print("[DEBUG] New state \(state) of \(meal.text) transmit at \(section + 1) day in \(id) position")
        firebaseController?.sendMealAndCalState(
            mealState: state,
            calories: cal,
            forDay: section + 1,
            forMeal: meal.engText,
            forID: id + 1) { [weak self] error in
                // Блок проверок
                guard (error == nil) else { return }
                guard (self != nil) else { return }
            
                // Обновление внутренней БД и отображения
                mealData.changeState(toState: state)
                self!.saveDatabase()
                self!.output?.updateMealData(forMeal: meal, atSection: section)
            }
    }
    
    // Запрос на получение данных
    func getDatabase() {
        print("[DEBUG] Request to download all data")
        output?.updateNumOfDays(numOfDays())
        firebaseController?.loadIndividualInfo { _ in return }
        firebaseController?.loadCommonInfo { [weak self] error in
            // Блок проверок
            guard (error == nil) else { return }
            guard (self != nil) else { return }
            
            // Обработка данных
            guard let daysCount = self!.firebaseController?.getDaysCount() else { return }
            self!.createCellData(withNewDays: daysCount)
            self!.output?.updateNumOfDays(daysCount)
        }
    }
}

// Внешние запросы
extension DietScreenInteractor: DietScreenInteractorInput {
    func findMeal(forString text: String) -> [SearchStruct] {
        var output: [SearchStruct] = []
        let downText = text.lowercased()
        
        cellData.forEach({ data in
            let section = data.section()
            let newMealType = data.type().revert
            data.cellMeals?.forEach({ mealSet in
                guard mealSet is MealData else { return }
                let mealID = (mealSet as! MealData).getID()
                let mealName = (mealSet as! MealData).modelName!.lowercased()
                if mealName.contains(downText) {
                    output.append(SearchStruct(
                        section: section,
                        mealType: newMealType,
                        id: mealID))
                }
            })
        })
        return output
    }
    
    func getCurrentDay() -> Int {
        return firebaseController?.getCurrentDay() ?? 0
    }
    
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
}
