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
    
    private var rowInSection: [[MealsType]] = []
    
    init(router: DietScreenRouterInput, interactor: DietScreenInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
    
    // Подготовка к добавлению или удачению ячеек
    private func prepareCells(for disclosure: DisclosureState, mealType celltype: MealsType, atSection section: Int) -> [IndexPath] {
        // Проверка на обращение к несуществующей секции
        if (rowInSection.count <= section) { return [] }

        // Получение числа ячеек для добавления
        let mealDataSize = interactor.getMealCount(forMeal: celltype, atSection: section)
        if mealDataSize == 0 { return [] }
        
        // Получение массива индексов для добавления во вьюху
        var mealIndexPath: [IndexPath] = []
        let dietCellIndex = getCellIndex(forMeal: celltype, atSection: section)
        for i in (1...mealDataSize).reversed() {
            mealIndexPath.append(IndexPath(row: dietCellIndex + i, section: section))
        }
        
        // Обновление массива отображаемых ячеек
        let cellTypeForUpdate = celltype.revert
        if disclosure != .disclosure {
            rowInSection[section].removeAll(where: {$0 == cellTypeForUpdate})
        }
        if disclosure != .closure {
            rowInSection[section].insert(contentsOf: Array(repeating: cellTypeForUpdate, count: mealDataSize), at: dietCellIndex + 1)
        }
        return mealIndexPath
    }
    
    private func mealPosition(forMeal meal: MealsType, atIndex indexPath: IndexPath) -> Int {
        // Получение позиции родительской ячейки и блока данных
        let dietCellIndex = self.getCellIndex(forMeal: meal, atSection: indexPath.section)
        let dietCellData = self.getCellInfo(forMeal: meal, atSection: indexPath.section)
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
    // Получение информации о блюде
    func getMealData(forMeal meal: MealsType, atIndex indexPath: IndexPath) -> MealInfo {
        // Получение базы данных родительской ячейки
        let dietCellData = self.getCellInfo(forMeal: meal, atSection: indexPath.section)
        
        // Получение данных для текущей ячейки блюда
        return dietCellData.meals[self.mealPosition(forMeal: meal, atIndex: indexPath)]
    }
    
    // Получение номера строки ячейки
    func getCellIndex(forMeal meal: MealsType, atSection section: Int) -> Int {
        guard let index = rowInSection[section].firstIndex(of: meal) else {
            fatalError("Can't find cell index for \(meal.text)!")
        }
        return index
    }
    
    // Получение данных для ячейки
    func getCellInfo(forMeal meal: MealsType, atSection section: Int) -> CellInfo {
        return interactor.getCellInfo(forMeal: meal, atSection: section)
    }
    
    // Получение типа ячейки по индексу
    func getCellType(from indexPath: IndexPath) -> MealsType {
        if (rowInSection.count <= indexPath.section || rowInSection[indexPath.section].count <= indexPath.row) {
            return .none
        }
        return rowInSection[indexPath.section][indexPath.row]
    }
    
    // Получения количества секций
    func getNumOfDay() -> Int {
        return rowInSection.count
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
    func requestNumOfDays() {
        interactor.requestNumOfDays()
    }
}

// Обработчики нажатий на ячейки
extension DietScreenPresenter {
    func clickedDiet(_ state: DisclosureState, mealType celltype: MealsType, inSection section: Int) {
        // Изменение состояния раскрытия в базе данных
        interactor.changeDisclosure(toState: state, forMeal: celltype, atSection: section)
        
        // Обновление базы данных и показанных ячеек
        let mealIndexPath = self.prepareCells(for: state, mealType: celltype, atSection: section)
        if state == .disclosure {
            view?.showCells(for: mealIndexPath)
        } else if state == .closure {
            view?.hideCells(for: mealIndexPath)
        }
    }

    func clickedMeal(_ state: Bool, forMeal celltype: MealsType, atIndex indexPath: IndexPath) {
        let position = self.mealPosition(forMeal: celltype, atIndex: indexPath)
        interactor.changeMealState(toState: state, atIndex: position, forMeal: celltype, atSection: indexPath.section)
    }
}

// Обработчики ответа от интерактора
extension DietScreenPresenter: DietScreenInteractorOutput {
    func updateMealData(_ meals: [MealInfo], forMeal meal: MealsType, atSection section: Int) {
        if (rowInSection.count <= section) { return }
        
        // Обновление блюд, если ячейка открыта
        if interactor.getCellInfo(forMeal: meal, atSection: section).disclosureState == .disclosure {
            // Обновление базы данных и показанных ячеек
            let _ = self.prepareCells(for: .reload, mealType: meal, atSection: section)
        }
        
        // Перезагрузка таблицы
        view?.reloadTableView()
    }
    
    func updateNumOfDays(_ days: Int) {
        // Создание начальных полей секции
        for curSection in 0...days-1 {
            rowInSection.insert([.breakfast, .lunch, .dinner], at: curSection)
        }
        // Перезагрузка таблицы
        view?.reloadTableView()
    }
}

extension DietScreenPresenter: DietScreenModuleInput {}
