//
//  DietScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation
import CoreData

final class DietScreenInteractor {
    private var cellData: [CellInfo] = []
	weak var output: DietScreenInteractorOutput?
    private var numOfDays: Int = 0
    
    // Базы данных
    private let modelController: DietModelController
    private let coreDataContext: NSManagedObjectContext
    private var firebaseModelController: DietFirebaseModelController
    
    init() {
        modelController = DietModelController()
        coreDataContext = modelController.managedObjectContext
        firebaseModelController = DietFirebaseModelController()
        firebaseModelController.login(completion: self.requestNumOfDays)
        _ = createCellData()
        uploadFromDatabase()
    }
    
    deinit {
        defaults.set(numOfDays, forKey: "dietDays")
        modelController.saveContext()
    }
    
    // Создание внутреннего кэша данных по каждому приёму пищи
    private func createCellData(withNewDays days: Int = 0) -> Bool {
        let oldDays = numOfDays
        numOfDays = days
        if numOfDays < oldDays {
            cellData.removeSubrange(numOfDays...oldDays-1)
            return true
        } else if numOfDays > oldDays {
            for curSection in oldDays...numOfDays-1 {
                self.cellData.append(contentsOf: [
                    CellInfo(curSection, initType: .breakfast),
                    CellInfo(curSection, initType: .lunch),
                    CellInfo(curSection, initType: .dinner)
                ])
            }
            return true
        }
        return false
    }
    
    // Загрузка данных из локальной БД
    private func uploadFromDatabase() {
        do {
            let fetchRequest = MealData.fetchRequest()
            let result = try coreDataContext.fetch(fetchRequest)
            addMeals(result)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Добавление полученных блюд во внутренний кэш
    private func addMeals(_ meals: [MealData]) {
        var dietsForUpdate: Set<Int> = []
        for meal in meals {
            let section = Int(meal.modelDay) - 1
            if section >= numOfDays { continue }
            
            let celltype = MealsType(Int(meal.modelDiet))
            let mealID = Int(meal.modelID)
            let cellDataIndex = self.cellIndex(forMeal: celltype, atSection: section)
            dietsForUpdate.insert(cellDataIndex)
            guard let mealDataIndex = self.mealIndex(forCellPosition: cellDataIndex, atID: mealID) else {
                modelController.saveContext()
                cellData[cellDataIndex].addMeal(to: meal)
                continue
            }
            cellData[cellDataIndex].meals[mealDataIndex].copyFrom(meal)
            
            coreDataContext.delete(meal)
            modelController.saveContext()
        }
        dietsForUpdate.forEach({ cellIndex in
            output?.updateMealData(forMeal: cellData[cellIndex].cellType, atSection: cellData[cellIndex].section)
        })
    }
    
    // Получение позиции данных ячейки из внутреннего кэша
    private func cellIndex(forMeal meal: MealsType, atSection section: Int) -> Int {
        guard let index = cellData.firstIndex(where: { $0.section == section && $0.cellType == meal }) else {
            fatalError("Can't find cell index for \(meal.text)!")
        }
        return index
    }
    
    // Получение позиции блюда для ячейки из внутреннего кэша по ID
    private func mealIndex(forCellPosition position: Int, atID id: Int) -> Int? {
        return cellData[position].meals.firstIndex(where: ) { meal in
            return meal.modelID == id
        }
    }
    
    private func deleteMeals(greaterThanID id: UInt, forMeal meal: MealsType, inSection section: Int) {
        let oldNumOfMeals = UInt(self.getMealCount(forMeal: meal, atSection: section))
        if id < oldNumOfMeals {
            for mealID in id...oldNumOfMeals-1 {
                let cellDataIndex = self.cellIndex(forMeal: meal, atSection: section)
                guard let mealDataIndex = self.mealIndex(forCellPosition: cellDataIndex, atID: Int(mealID)) else {
                    fatalError("Can't find meal index for mealID: \(mealID)")
                }
                self.coreDataContext.delete(cellData[cellDataIndex].meals.remove(at: mealDataIndex))
            }
        }
    }
}

// Firebase методы
extension DietScreenInteractor {
    // Запрос на получение данных из Firebase
    private func requestMealData(toDay day: Int, toMeal mealtype: MealsType) {
        print("[DEBUG] Data from \(mealtype.text) need to get at \(day) day")
        firebaseModelController.getMeals(forDay: day, atMeal: mealtype.engText) { [weak self] numOfMeals in
            guard (self != nil) else { return }
            
            // Удаление лишних блюд
            self!.deleteMeals(greaterThanID: numOfMeals, forMeal: mealtype, inSection: day - 1)
            if numOfMeals == 0 { return }
            
            // Обновление блюд
            var meals: [MealData] = []
            for mealNumber in 1...numOfMeals {
                meals.append(MealData(
                    id: Int(mealNumber) - 1,
                    nameString: self!.firebaseModelController.mealName(forID: mealNumber),
                    calories: self!.firebaseModelController.mealCalories(forID: mealNumber),
                    state: self!.firebaseModelController.mealState(forID: mealNumber),
                    day: day,
                    diet: mealtype,
                    context: self!.coreDataContext)
                )
            }
            // Добавление блюд
            self!.addMeals(meals)
        }
    }
    
    // Запись информации о состоянии блюда в FireBase
    private func transmitMealState(_ state: Bool, atPosition position: Int, forMeal celltype: MealsType, inDay day: Int) {
        print("[DEBUG] New state of \(celltype.text) transmit at \(day) day in \(position) position")
    }
    
    // Запрос на получение числа дней
    func requestNumOfDays() {
        print("[DEBUG] Need get num of days")
        firebaseModelController.daysCount() { [weak self] days in
            guard (self != nil) else { return }
            if self!.createCellData(withNewDays: Int(days)) {
                self!.output?.updateNumOfDays(self!.numOfDays)
                self!.uploadFromDatabase()
            }
        }
    }
}

// Внешние запросы
extension DietScreenInteractor: DietScreenInteractorInput {
    // Получение данных о блюде
    func getMealData(withID id: Int, forMeal meal: MealsType, atSection section: Int) -> MealData {
        let cellDataIndex = self.cellIndex(forMeal: meal, atSection: section)
        guard let mealDataIndex = self.mealIndex(forCellPosition: cellDataIndex, atID: id) else {
            fatalError("Can't find meal index for mealID: \(id)")
        }
        return cellData[cellDataIndex].meals[mealDataIndex]
    }
    
    // Получение данных о ячейки
    func getCellInfo(forMeal meal: MealsType, atSection section: Int) -> CellInfo {
        let cellDataIndex = self.cellIndex(forMeal: meal, atSection: section)
        return cellData[cellDataIndex]
    }
    
    // Получение числа блюд для каждой ячейки
    func getMealCount(forMeal meal: MealsType, atSection section: Int) -> Int {
        let data = cellData[self.cellIndex(forMeal: meal, atSection: section)]
        let maxMealID = Int(data.meals.max(by: { low, high in
            low.modelID < high.modelID
        })?.modelID ?? -1) + 1
        return maxMealID
    }
    
    // Обработка изменения состояния блюда
    func changeMealState(toState state: Bool, withID id: Int, forMeal meal: MealsType, atSection section: Int) {
        self.transmitMealState(state, atPosition: id, forMeal: meal, inDay: section + 1)
//        let ifErrorState = !state
//        output?.undoChangeMealState(ifErrorState, withID: id, forMeal: meal, atSection: section)
//        return
        self.getMealData(withID: id, forMeal: meal, atSection: section).changeState(toState: state)
    }
    
    // Обработка изменения состояния раскрывающейся ячейки
    func changeDisclosure(toState state: DisclosureState, forMeal meal: MealsType, atSection section: Int) {
        let cellDataIndex = self.cellIndex(forMeal: meal, atSection: section)
        cellData[cellDataIndex].changeDisclosure(toState: state)
        
        // Запрос на сервер если ячейка открыта
        if state == .disclosure {
            self.requestMealData(toDay: section + 1, toMeal: meal)
        }
    }
}
