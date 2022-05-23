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
    private var searchRow: [[SearchStruct]] = []
    
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
        guard searchRow.isEmpty else {
            let id = searchRow[indexPath.section][indexPath.row].id
            let section = searchRow[indexPath.section][indexPath.row].section
            return interactor.getMealData(withID: id, forMeal: meal, atSection: section)
        }
        let id = self.mealPosition(forMeal: meal, fromIndexPath: indexPath)
        return interactor.getMealData(withID: id, forMeal: meal, atSection: indexPath.section)
    }
    
    // Получение номера строки ячейки
    private func getCellIndex(forMeal meal: MealsType, atSection section: Int) -> Int {
        guard let index = rowInSection[section].firstIndex(of: meal) else {
            fatalError("Can't find cell index for \(meal.text)!")
        }
        return index
    }
    
    // Обновление блюд по секцииям
    private func updateMealData(atSection section: Int) {
        guard rowInSection.count > section else { return }
        
        // Обновление блюд, если ячейка открыта
        if self.getCellDisclosure(forMeal: .breakfast, atSection: section) == .disclosure {
            // Обновление базы данных и показанных ячеек
            let _ = self.prepareCells(for: .reload, mealType: .breakfast, atSection: section)
        }
        if self.getCellDisclosure(forMeal: .lunch, atSection: section) == .disclosure {
            // Обновление базы данных и показанных ячеек
            let _ = self.prepareCells(for: .reload, mealType: .lunch, atSection: section)
        }
        if self.getCellDisclosure(forMeal: .snack, atSection: section) == .disclosure {
            // Обновление базы данных и показанных ячеек
            let _ = self.prepareCells(for: .reload, mealType: .snack, atSection: section)
        }
        if self.getCellDisclosure(forMeal: .dinner, atSection: section) == .disclosure {
            // Обновление базы данных и показанных ячеек
            let _ = self.prepareCells(for: .reload, mealType: .dinner, atSection: section)
        }
    }
}

// Геттеры
extension DietScreenPresenter: DietScreenViewOutput {
    func getDay(for section: Int) -> Int {
        guard searchRow.isEmpty else {
            return (searchRow[section].first?.section ?? -1) + 1
        }
        return section + 1
    }
    
    // Отмена поиска
    func searchEnd() {
        searchRow.removeAll()
        view?.reloadTableView()
    }
    
    // Поиск блюд
    func searchMeal(forString searchText: String) {
        searchRow.removeAll()
        
        // Поиск по номеру дня
        guard Int(searchText) == nil else {
            let section = Int(searchText)! - 1
            let rows = rowInSection[section]
            var parentIndex = 0
            searchRow.insert([], at: 0)
            for (i, row) in rows.enumerated() {
                if row == .dinner || row == .lunch || row == .breakfast || row == .snack {
                    parentIndex = i
                }
                let id = i - parentIndex - 1
                searchRow[0].append(SearchStruct(section: section, mealType: row, id: id))
            }
            view?.reloadTableView()
            return
        }
        
        // Поиск по блюдам
        let mealsIndexes = interactor.findMeal(forString: searchText)
        for mealsIndex in mealsIndexes {
            let section = mealsIndex.section
            let parentMeal = mealsIndex.mealType.revert
            
            // Поиск секции в которую можно вставить ячейку
            guard let sectionIndex = searchRow.firstIndex(where: {
                guard $0.count != 0 else { return false }
                return $0[0].section == section
            // Если такой секции нет
            }) else {
                // Вставка для первой секциии
                guard section != 0 else {
                    searchRow.insert([SearchStruct(section: section, mealType: parentMeal, id: -1), mealsIndex], at: 0)
                    continue
                }
                
                // Поиск секции после которой в ставлять новую секцию
                guard let index = searchRow.firstIndex(where: {
                    guard $0.count != 0 else { return false }
                    return $0[0].section < section
                // Если таких секции нет
                }) else {
                    searchRow.insert([SearchStruct(section: section, mealType: parentMeal, id: -1), mealsIndex], at: 0)
                    continue
                }
                // Если такая секция существует
                searchRow.insert([SearchStruct(section: section, mealType: parentMeal, id: -1), mealsIndex], at: index + 1)
                continue
            }
            // Если такая секция существует
            searchRow[sectionIndex].append(mealsIndex)
        }
        searchRow = searchRow.sorted(by: { first, second in
            first[0].section < second[0].section
        })
        view?.reloadTableView()
    }
    
    // Получение номера текущего дня
    func getCurrentDay() -> Int {
        return interactor.getCurrentDay()
    }
    
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
    
    // Получение состояния ячейки
    func getCellDisclosure(forMeal meal: MealsType, atSection section: Int) -> DisclosureState {
        return searchRow.isEmpty ? DisclosureState(interactor.getCellData(forMeal: meal, atSection: section).cellDisclosure) : .disclosure
    }
    
    // Получение типа ячейки по индексу
    func getCellType(from indexPath: IndexPath) -> MealsType {
        guard searchRow.isEmpty else {
            if (searchRow.count <= indexPath.section || searchRow[indexPath.section].count <= indexPath.row) { return .none }
            return searchRow[indexPath.section][indexPath.row].mealType
        }
        if (rowInSection.count <= indexPath.section || rowInSection[indexPath.section].count <= indexPath.row) { return .none }
        return rowInSection[indexPath.section][indexPath.row]
    }
    
    // Получения количества секций
    func getNumOfDay() -> Int {
        return searchRow.isEmpty ? rowInSection.count : searchRow.count
    }
    
    // Получение числа строк к секции
    func getNumOfRows(inSection section: Int) -> Int {
        guard searchRow.isEmpty else {
            guard searchRow.count > section else { return 0 }
            return searchRow[section].count
        }
        guard rowInSection.count > section else { return 0 }
        return rowInSection[section].count
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
    // Нажатие на приём пищи
    func clickedDiet(_ state: DisclosureState, mealType celltype: MealsType, inSection section: Int) {
        // Защита от тыка
        guard searchRow.isEmpty else {
            view?.reloadTableView()
            return
        }
        
        // Изменение состояния раскрытия в базе данных
        interactor.changeDisclosure(toState: state, forMeal: celltype, atSection: section)
        
        // Обновление базы данных и показанных ячеек
        let mealsIndexPath = self.prepareCells(for: state, mealType: celltype, atSection: section)
        if state == .disclosure {
            view?.showCells(for: mealsIndexPath)
        } else if state == .closure {
            view?.hideCells(for: mealsIndexPath)
        }
    }

    // Нажатие на блюдо
    func clickedMeal(forMeal celltype: MealsType, atIndex indexPath: IndexPath) {
        // Защита от тыка
        guard searchRow.isEmpty else { return }
        
        // Получение индекса нажататой ячейки
        let id = self.mealPosition(forMeal: celltype, fromIndexPath: indexPath)
        interactor.changeMealState(withID: id, forMeal: celltype, atSection: indexPath.section)
    }
}

// Обработчики ответа от интерактора
extension DietScreenPresenter: DietScreenInteractorOutput {
    // Обновление блюд после появления данных
    func updateMealData(forMeal meal: MealsType, atSection section: Int) {
        guard rowInSection.count > section else { return }
        
        // Обновление блюд, если ячейка открыта
        if self.getCellDisclosure(forMeal: meal, atSection: section) == .disclosure {
            // Обновление базы данных и открытых ячеек
            let rowsBeforeUpdate = rowInSection[section].count
            var mealsIndexPath = self.prepareCells(for: .reload, mealType: meal, atSection: section)
            let rowsAfterUpdate = rowInSection[section].count
            let countNewCells = rowsAfterUpdate - rowsBeforeUpdate
            
            // Если идет поиск, то обновления отображения нет
            guard searchRow.isEmpty else { return }
            
            // Обновление отображения
            if countNewCells >= 0 {
                view?.showCells(for: mealsIndexPath.suffix(countNewCells))
                mealsIndexPath.removeLast(countNewCells)
            } else {
                let lastRow = mealsIndexPath.last?.row ?? getCellIndex(forMeal: meal, atSection: section)
                var deletedCells: [IndexPath] = []
                for row in lastRow+1...lastRow-countNewCells {
                    deletedCells.append(IndexPath(row: row, section: section))
                }
                view?.hideCells(for: deletedCells)
            }
            view?.reloadTableRows(atIndex: mealsIndexPath, animation: .none)
        }
    }
    
    // Получение числа дней
    func updateNumOfDays(_ days: Int) {
        let lastNumOfDays = rowInSection.count
        
        // Создание начальных полей секции
        if days > lastNumOfDays {
            for curSection in lastNumOfDays...days-1 {
                rowInSection.insert([.breakfast, .lunch, .snack, .dinner], at: curSection)
                
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
        guard searchRow.isEmpty else { return }
        view?.reloadTableView()
    }
}

extension DietScreenPresenter: DietScreenModuleInput {}
