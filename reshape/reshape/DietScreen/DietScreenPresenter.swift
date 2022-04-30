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
        switch disclosure {
        case .closure:
            rowInSection[section].removeAll(where: {$0 == cellTypeForUpdate})
        case .disclosure:
            rowInSection[section].insert(contentsOf: Array(repeating: cellTypeForUpdate, count: mealDataSize), at: dietCellIndex + 1)
        case .reload:
            rowInSection[section].removeAll(where: {$0 == cellTypeForUpdate})
            rowInSection[section].insert(contentsOf: Array(repeating: cellTypeForUpdate, count: mealDataSize), at: dietCellIndex + 1)
        }
        return mealIndexPath
    }
    
    private func mealPosition(forMeal meal: MealsType, fromIndexPath indexPath: IndexPath) -> Int {
        // Получение позиции родительской ячейки и блока данных
        let dietCellIndex = self.getCellIndex(forMeal: meal, atSection: indexPath.section)
        let position = indexPath.row - dietCellIndex - 1
        
        // Проверка на размер блока данных
        if position >= interactor.getMealCount(forMeal: meal, atSection: indexPath.section) {
            fatalError("Cell is null!")
        }
        return position
    }
    
    private func mealPosition(forMeal meal: MealsType, fromID id: Int, atSection section: Int) -> IndexPath {
        // Получение позиции родительской ячейки и блока данных
        let dietCellIndex = self.getCellIndex(forMeal: meal, atSection: section)
        let row = id + dietCellIndex + 1
        return IndexPath(row: row, section: section)
    }
    
    // Получение информации о блюде
    private func getMealData(forMeal meal: MealsType, atIndex indexPath: IndexPath) -> MealData {
        let id = self.mealPosition(forMeal: meal, fromIndexPath: indexPath)
        return interactor.getMealData(withID: id, forMeal: meal, atSection: indexPath.section)
    }
}

// Геттеры
extension DietScreenPresenter: DietScreenViewOutput {
    // Получение состояния блюда
    func getMealState(forMeal meal: MealsType, atIndex indexPath: IndexPath) -> Bool {
        return getMealData(forMeal: meal, atIndex: indexPath).modelState
    }
    
    // Получение названия блюда
    func getMealName(forMeal meal: MealsType, atIndex indexPath: IndexPath) -> String {
        return getMealData(forMeal: meal, atIndex: indexPath).modelName ?? ""
    }
    
    // Получение калорийности
    func getMealCalories(forMeal meal: MealsType, atIndex indexPath: IndexPath) -> Double {
        return getMealData(forMeal: meal, atIndex: indexPath).modelCalories
    }
    
    // Получение номера строки ячейки
    func getCellIndex(forMeal meal: MealsType, atSection section: Int) -> Int {
        guard let index = rowInSection[section].firstIndex(of: meal) else {
            fatalError("Can't find cell index for \(meal.text)!")
        }
        return index
    }
    
    // Получение состояния ячейки
    func getCellDisclosure(forMeal meal: MealsType, atSection section: Int) -> DisclosureState {
        return DisclosureState(interactor.getCellData(forMeal: meal, atSection: section).cellDisclosure)
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
    func requestData() {
        interactor.getDatabase()
    }
    
    // Сохранение БД
    func saveData() {
        interactor.saveDatabase()
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
        let id = self.mealPosition(forMeal: celltype, fromIndexPath: indexPath)
        interactor.changeMealState(toState: state, withID: id, forMeal: celltype, atSection: indexPath.section)
    }
}

// Обработчики ответа от интерактора
extension DietScreenPresenter: DietScreenInteractorOutput {
    func updateMealData(forMeal meal: MealsType, atSection section: Int) {
        if (rowInSection.count <= section) { return }
        
        // Обновление блюд, если ячейка открыта
        if self.getCellDisclosure(forMeal: meal, atSection: section) == .disclosure {
            // Обновление базы данных и показанных ячеек
            let _ = self.prepareCells(for: .reload, mealType: meal, atSection: section)
        }
        
        // Перезагрузка таблицы
        view?.reloadTableSections(atSection: IndexSet(integer: section))
    }
    
    func updateMealData(atSection section: Int) {
        if (rowInSection.count <= section) { return }
        
        // Обновление блюд, если ячейка открыта
        if self.getCellDisclosure(forMeal: .breakfast, atSection: section) == .disclosure {
            // Обновление базы данных и показанных ячеек
            let _ = self.prepareCells(for: .reload, mealType: .breakfast, atSection: section)
        }
        if self.getCellDisclosure(forMeal: .lunch, atSection: section) == .disclosure {
            // Обновление базы данных и показанных ячеек
            let _ = self.prepareCells(for: .reload, mealType: .lunch, atSection: section)
        }
        if self.getCellDisclosure(forMeal: .dinner, atSection: section) == .disclosure {
            // Обновление базы данных и показанных ячеек
            let _ = self.prepareCells(for: .reload, mealType: .dinner, atSection: section)
        }
    }
    
    func updateNumOfDays(_ days: Int) {
        let lastNumOfDays = rowInSection.count
        
        // Создание начальных полей секции
        if days > lastNumOfDays {
            for curSection in lastNumOfDays...days-1 {
                rowInSection.insert([.breakfast, .lunch, .dinner], at: curSection)
                
                // Получение блюд, если открыты ячейки
                self.updateMealData(atSection: curSection)
            }
        } else if days < lastNumOfDays {
            for curSection in days...lastNumOfDays-1 {
                rowInSection.remove(at: curSection)
            }
        } else {
            return
        }
        
        // Перезагрузка таблицы
        view?.reloadTableView()
    }
}

extension DietScreenPresenter: DietScreenModuleInput {}
