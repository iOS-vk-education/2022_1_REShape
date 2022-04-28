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
    private let modelController: DietModelController
    private let coreDataContext: NSManagedObjectContext
    private var numOfDays: Int
    
    init(coreDataController: DietModelController) {
        modelController = coreDataController
        coreDataContext = modelController.managedObjectContext
        numOfDays = (defaults.value(forKey: "dietDays") as? Int) ?? 0
        createCellData()
        uploadFromDatabase()
    }
    
    deinit {
        defaults.set(numOfDays, forKey: "dietDays")
        modelController.saveContext()
    }
    
    // Создание внутреннего кэша данных по каждому приёму пищи
    private func createCellData() {
        if numOfDays <= 0 { return }
        for curSection in 0...numOfDays-1 {
            self.cellData.insert(contentsOf: [
                CellInfo(curSection, initType: .breakfast),
                CellInfo(curSection, initType: .lunch),
                CellInfo(curSection, initType: .dinner)
            ], at: curSection)
        }
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
    
    // Преобразование полученных данных из Firebase
    private func transformMealData(_ meals: [FireBaseMealData]) -> [MealData] {
        // Получение индекса ячейки
        var cellMeals: [MealData] = []
        meals.enumerated().forEach() { pos, data in
            cellMeals.insert(MealData.transform(firebaseDatabase: data, context: coreDataContext), at: pos)
        }
        return cellMeals
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
//                coreDataContext.insert(meal) // TODO
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
}

// Firebase методы
extension DietScreenInteractor {
    // Запрос на получение данных из Firebase
    private func requestMealData(toDay day: Int, toMeal mealtype: MealsType) {
        print("[DEBUG] Data from \(mealtype.text) need to get at \(day) day")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
            let fireBaseMealData: [FireBaseMealData] = [
                FireBaseMealData(name: "first", cal: 400, checked: true, id: 0, day: day, diet: mealtype),
                FireBaseMealData(name: "second", cal: 300, checked: false, id: 1, day: day, diet: mealtype)
            ]
            
            // Обновление данных ячеек
            let transformData = self.transformMealData(fireBaseMealData)
            self.addMeals(transformData)
        })
    }
    
    // Запись информации о состоянии блюда в FireBase
    private func transmitMealState(_ state: Bool, atPosition position: Int, forMeal celltype: MealsType, inDay day: Int) {
        print("[DEBUG] New state of \(celltype.text) transmit at \(day) day in \(position) position")
    }
    
    // Запрос на получение числа дней
    func requestNumOfDays() {
        print("[DEBUG] Need get num of days")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.numOfDays = 10
            self.createCellData()
            self.output?.updateNumOfDays(self.numOfDays)
            self.uploadFromDatabase()
        })
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
