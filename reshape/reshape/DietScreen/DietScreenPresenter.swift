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
    private func prepareCells(for disclosure: DisclosureState, mealType celltype: MealsType, atSection section: Int)
    -> [IndexPath] {
        if (rowInSection.count <= section) { return [] }
        guard let data = cellData.first(where: { $0.section == section && $0.cellType == celltype }) else { return [] }
        guard let dietCellIndex = rowInSection[section].firstIndex(of: celltype) else { return [] }

        let cellTypeForRemove = celltype.revert
        let mealDataSize = data.meals.count
        if mealDataSize == 0 { return [] }
        var mealIndexPath: [IndexPath] = []
        for i in (1...mealDataSize).reversed() {
            mealIndexPath.append(IndexPath(row: dietCellIndex + i, section: section))
        }
        if disclosure != .disclosure {
            rowInSection[section].removeAll(where: {$0 == cellTypeForRemove})
        }
        if disclosure != .closure {
            rowInSection[section].insert(contentsOf: Array(repeating: cellTypeForRemove, count: mealDataSize), at: dietCellIndex + 1)
        }
        return mealIndexPath
    }

    // Обработка изменения состояния раскрывающейся ячейки
    private func changeDisclosure(toState state: DisclosureState, forMeal meal: MealsType, fromSection section: Int) {
        let dataCellIndex = self.indexOfCellData(forMeal: meal, atSection: section)
        cellData[dataCellIndex].changeDisclosure(toState: state)
    }

    // Обработка изменения состояния блюда
    private func changeMealState(toState state: Bool, atIndex index: Int, forMeal meal: MealsType, fromSection section: Int) {
        let dataCellIndex = self.indexOfCellData(forMeal: meal, atSection: section)
        interactor.setMealState(state, atPosition: index, forMeal: meal, inDay: section + 1)
        cellData[dataCellIndex].changeMealState(atIndex: index, toState: state)
    }
    
    // Получение позиции данных для базы данных
    private func indexOfCellData(forMeal meal: MealsType, atSection section: Int) -> Int {
        guard let index = cellData.firstIndex(where: { $0.section == section && $0.cellType == meal }) else {
            fatalError("Can't find cell index for \(meal.text)!")
        }
        return index
    }
    
    private func mealPosition(forMeal meal: MealsType, atIndex indexPath: IndexPath) -> Int {
        // Получение позиции родительской ячейки и блока данных
        let dietCellIndex = self.getCellIndex(forMeal: meal, atSection: indexPath.section)
        let dietCellData = self.getCellData(forMeal: meal, atSection: indexPath.section)
        let position = indexPath.row - dietCellIndex - 1
        
        // Проверка на размер блока данных
        if position >= dietCellData.meals.count {
            fatalError("Cell is null!")
        }
        return position
    }
}

// Геттеры
extension DietScreenPresenter: DietScreenViewOutput {
    func getMealData(forMeal meal: MealsType, atIndex indexPath: IndexPath) -> Meals {
        // Получение базы данных родительской ячейки
        let dietCellData = self.getCellData(forMeal: meal, atSection: indexPath.section)
        
        // Получение данных для текущей ячейки блюда
        return dietCellData.meals[self.mealPosition(forMeal: meal, atIndex: indexPath)]
    }
    
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
}

// Обработчики нажатий на ячейки
extension DietScreenPresenter {
    func checkedDiet(mealType celltype: MealsType, inSection section: Int) {
        // Изменение состояния раскрытия
        self.changeDisclosure(toState: .disclosure, forMeal: celltype, fromSection: section)
        
        // Запрос на сервер
        interactor.getMealList(toDay: section + 1, toMeal: celltype)
        
        // Обновление базы данных и показанных ячеек
        let mealIndexPath = self.prepareCells(for: .disclosure, mealType: celltype, atSection: section)
        view?.showCells(for: mealIndexPath)
    }
    
    func uncheckedDiet(mealType celltype: MealsType, inSection section: Int) {
        self.changeDisclosure(toState: .closure, forMeal: celltype, fromSection: section)
        
        // Обновление базы данных и показанных ячеек
        let mealIndexPath = self.prepareCells(for: .closure, mealType: celltype, atSection: section)
        view?.hideCells(for: mealIndexPath)
    }
    
    func checkedMeal(forMeal celltype: MealsType, atIndex indexPath: IndexPath) {
        let position = self.mealPosition(forMeal: celltype, atIndex: indexPath)
        self.changeMealState(toState: true, atIndex: position, forMeal: celltype, fromSection: indexPath.section)
    }
    
    func uncheckedMeal(forMeal celltype: MealsType, atIndex indexPath: IndexPath) {
        let position = self.mealPosition(forMeal: celltype, atIndex: indexPath)
        self.changeMealState(toState: false, atIndex: position, forMeal: celltype, fromSection: indexPath.section)
    }
}

// Обработчики ответа от интерактора
extension DietScreenPresenter: DietScreenInteractorOutput {
    func setMealList(_ meals: [Meals], day: Int, celltype: MealsType) {
        if (rowInSection.count < day) { return }
        
        // Получение индекса ячейки
        let dataIndex = self.indexOfCellData(forMeal: celltype, atSection: day - 1)
        // Обновление данных ячеек
        cellData[dataIndex].updateMeals(to: meals)
        
        if cellData[dataIndex].disclosureState == .disclosure {
            // Обновление базы данных и показанных ячеек
            let _ = self.prepareCells(for: .reload, mealType: celltype, atSection: day - 1)
        }
        
        // Перезагрузка таблицы
        view?.reloadTableView()
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
        // Перезагрузка таблицы
        view?.reloadTableView()
    }
}

extension DietScreenPresenter: DietScreenModuleInput {}
