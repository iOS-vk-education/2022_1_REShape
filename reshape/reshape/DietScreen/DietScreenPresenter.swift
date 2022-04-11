//
//  DietScreenPresenter.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

final class DietScreenPresenter {
	weak var view: DietScreenViewInput?
    weak var moduleOutput: DietScreenModuleOutput?
    
	private let router: DietScreenRouterInput
	private let interactor: DietScreenInteractorInput
    
    private var cellData: [CellInfo] = []
    private var rowInSection: [[MealsType]] = []
    private var numOfSec: Int = 0
    
    init(router: DietScreenRouterInput, interactor: DietScreenInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
    
    // Подготовка к добавлению или удачению ячеек
    private func prepareCells(mealType celltype: MealsType, atSection section: Int)
    -> (cellTypeForRemove: MealsType, mealDataSize: Int, dietCellIndex: Int, mealIndexPath: [IndexPath])? {
        if (rowInSection.count <= section) { return nil }
        guard let data = cellData.first(where: { $0.section == section && $0.cellType == celltype }) else { return nil }
        guard let dietCellIndex = rowInSection[section].firstIndex(of: celltype) else { return nil }

        let cellTypeForRemove = celltype.revert
        let mealDataSize = data.meals.count
        if mealDataSize == 0 { return nil }
        var mealIndexPath: [IndexPath] = []
        for i in (1...mealDataSize).reversed() {
            mealIndexPath.append(IndexPath(row: dietCellIndex + i, section: section))
        }
        return (cellTypeForRemove, mealDataSize, dietCellIndex, mealIndexPath)
    }

    // Обработка изменения состояния раскрывающейся ячейки
    private func changeDisclosure(toState state: Bool, forMeal meal: MealsType, fromSection section: Int) {
        let dataCellIndex = self.indexOfCellData(forMeal: meal, atSection: section)
        cellData[dataCellIndex].changeDisclosure(toState: state)
    }

    // Обработка изменения состояния блюда
    private func changeMealState(toState state: Bool, atIndex index: Int, forMeal meal: MealsType, fromSection section: Int) {
        let dataCellIndex = self.indexOfCellData(forMeal: meal.revert, atSection: section)
        interactor.setMealState(state, atPosition: index, forMeal: meal, inDay: section + 1)
        cellData[dataCellIndex].changeMealState(atIndex: index, toState: state)
    }
    
    // Получение индекса для внутренней базе данных
    private func indexOfCellData(forMeal meal: MealsType, atSection section: Int) -> Int {
        guard let index = cellData.firstIndex(where: { $0.section == section && $0.cellType == meal }) else {
            fatalError("Can't find cell index for \(meal.text)!")
        }
        return index
    }
}

// Геттеры
extension DietScreenPresenter: DietScreenViewOutput {
    // Получение номера строки ячейки в секции
    func getCellIndex(forMeal meal: MealsType, atSection section: Int) -> Int {
        guard let index = rowInSection[section].firstIndex(of: meal) else {
            fatalError("Can't find cell index for \(meal.text)!")
        }
        return index
    }
    
    // Получение данных из ячейки в секции
    func getCellData(forMeal meal: MealsType, atSection section: Int) -> CellInfo {
        guard let info = cellData.first(where: { $0.section == section && $0.cellType == meal }) else {
            fatalError("Can't find cell information for \(meal.text)!")
        }
        return info
    }
    
    // Получение типа блюда по индексу
    func getMealType(from indexPath: IndexPath) -> MealsType {
        if (rowInSection.count <= indexPath.section || rowInSection[indexPath.section].count <= indexPath.row) {
            return .none
        }
        return rowInSection[indexPath.section][indexPath.row]
    }
    
    // Получения количества секций
    func getNumOfDay() -> Int {
        return numOfSec
    }
    
    // Получение числа строк к секции
    func getNumOfRows(inSection section: Int) -> Int {
        if rowInSection.count <= section { return 0 }
        else { return rowInSection[section].count }
    }
}

// Запросы от таблицы
extension DietScreenPresenter {
    // Запрос на получение количества дней и инициализация каждого дня
    func updateNumOfDays() {
        interactor.getNumOfDays()
    }
    
    // Запрос в интерактор на полученние новых данных
    func updateMealList(day: Int, mealtype: MealsType) {
        interactor.getMealList(toDay: day, toMeal: mealtype)
    }
}

// Обработчики нажатий на ячейки
extension DietScreenPresenter {
    func checkedDiet(mealType celltype: MealsType, inSection section: Int) {
        self.changeDisclosure(toState: true, forMeal: celltype, fromSection: section)
        guard let (cellTypeForRemove, mealDataSize, dietCellIndex, mealIndexPath) = self.prepareCells(mealType: celltype, atSection: section) else {
            return
        }
        rowInSection[section].insert(contentsOf: Array(repeating: cellTypeForRemove, count: mealDataSize), at: dietCellIndex + 1)
        view?.showCells(for: mealIndexPath)
    }
    
    func uncheckedDiet(mealType celltype: MealsType, inSection section: Int) {
        self.changeDisclosure(toState: false, forMeal: celltype, fromSection: section)
        guard let (cellTypeForRemove, _, _, mealIndexPath) = prepareCells(mealType: celltype, atSection: section) else {
            return
        }
        rowInSection[section].removeAll(where: {$0 == cellTypeForRemove})
        view?.hideCells(for: mealIndexPath)
    }
    
    func checkedMeal(atPosition position: Int, forMeal celltype: MealsType, inSection section: Int) {
        self.changeMealState(toState: true, atIndex: position, forMeal: celltype, fromSection: section)
    }
    
    func uncheckedMeal(atPosition position: Int, forMeal celltype: MealsType, inSection section: Int) {
        self.changeMealState(toState: false, atIndex: position, forMeal: celltype, fromSection: section)
    }
}

// Обработчики ответа от интерактора
extension DietScreenPresenter: DietScreenInteractorOutput {
    func setMealList(_ meals: [Meals], day: Int, celltype: MealsType) {
        if (rowInSection.count < day) { return }
        
        // Получение индекса ячейки
        let dataIndex = self.indexOfCellData(forMeal: celltype, atSection: day - 1)
        
        // Очистка ячеек из таблицы
        self.uncheckedDiet(mealType: celltype, inSection: day - 1)
        
        // Обновление данных ячеек
        cellData[dataIndex].updateMeals(to: meals)
        
        // Добавление ячеек с новыми данными
        self.checkedDiet(mealType: celltype, inSection: day - 1)
    }
    
    func setNumOfDays(_ days: Int) {
        numOfSec = days
        
        // Создание начальных полей секции
        for curSection in 0...numOfSec-1 {
            rowInSection.insert([.breakfast, .lunch, .dinner], at: curSection)
            cellData.append(contentsOf: [
                CellInfo(curSection, initType: .breakfast),
                CellInfo(curSection, initType: .lunch),
                CellInfo(curSection, initType: .dinner)
            ])
        }
        
        view?.reloadTableView()
    }
}

extension DietScreenPresenter: DietScreenModuleInput {}
