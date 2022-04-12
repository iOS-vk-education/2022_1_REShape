//
//  DietScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

final class DietScreenInteractor {
    private var cellData: [CellInfo] = []
	weak var output: DietScreenInteractorOutput?
    
    // Получение позиции данных для базы данных
    private func getCellIndex(forMeal meal: MealsType, atSection section: Int) -> Int {
        guard let index = cellData.firstIndex(where: { $0.section == section && $0.cellType == meal }) else {
            fatalError("Can't find cell index for \(meal.text)!")
        }
        return index
    }
    
    // Запись информации о состоянии блюда в FireBase
    private func transmitMealState(_ state: Bool, atPosition position: Int, forMeal celltype: MealsType, inDay day: Int) {
        print("[DEBUG] New state of \(celltype.text) transmit at \(day) day in \(position) position")
    }
    
    private func requestMealData(toDay day: Int, toMeal mealtype: MealsType) {
        print("[DEBUG] Data from \(mealtype.text) need to get at \(day) day")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let meal: [Meals] = [Meals(mealName: "first", calories: 400, check: true), Meals(mealName: "second", calories: 300)]
            self.setMealData(meal, day: day, celltype: mealtype)
        })
    }
    
    private func setMealData(_ meals: [Meals], day: Int, celltype: MealsType) {
        // Получение индекса ячейки
        let dataIndex = self.getCellIndex(forMeal: celltype, atSection: day - 1)
        // Обновление данных ячеек
        cellData[dataIndex].updateMeals(to: meals)
        output?.updateMealData(meals, forMeal: celltype, atSection: day - 1)
    }
}

extension DietScreenInteractor: DietScreenInteractorInput {
    // Получение информации о ячейки
    func getCellInfo(forMeal meal: MealsType, atSection section: Int) -> CellInfo {
        let cellInfoIndex = self.getCellIndex(forMeal: meal, atSection: section)
        return cellData[cellInfoIndex]
    }
    
    // Получение числа блюд для каждого приёма пищи
    func getMealCount(forMeal meal: MealsType, atSection section: Int) -> Int {
        let data = cellData[self.getCellIndex(forMeal: meal, atSection: section)]
        return data.meals.count
    }
    
    // Обработка изменения состояния блюда
    func changeMealState(toState state: Bool, atIndex index: Int, forMeal meal: MealsType, atSection section: Int) {
        let dataCellIndex = self.getCellIndex(forMeal: meal, atSection: section)
        self.transmitMealState(state, atPosition: index, forMeal: meal, inDay: section + 1)
        cellData[dataCellIndex].changeMealState(atIndex: index, toState: state)
    }
    
    // Обработка изменения состояния раскрывающейся ячейки
    func changeDisclosure(toState state: DisclosureState, forMeal meal: MealsType, atSection section: Int) {
        let dataCellIndex = self.getCellIndex(forMeal: meal, atSection: section)
        cellData[dataCellIndex].changeDisclosure(toState: state)
        
        // Запрос на сервер если ячейка открыта
        if state == .disclosure { self.requestMealData(toDay: section + 1, toMeal: meal) }
    }
    
    func requestNumOfDays() {
        print("[DEBUG] Need get num of days")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let days = 10
            for curSection in 0...days-1 {
                self.cellData.append(contentsOf: [
                    CellInfo(curSection, initType: .breakfast),
                    CellInfo(curSection, initType: .lunch),
                    CellInfo(curSection, initType: .dinner)
                ])
            }
            self.output?.updateNumOfDays(days)
        })
    }
}
