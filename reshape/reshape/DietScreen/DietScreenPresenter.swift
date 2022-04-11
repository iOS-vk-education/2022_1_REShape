//
//  DietScreenPresenter.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

enum MealsType {
    case breakfast, lunch, dinner, none,
         mealBreakfast, mealLunch, mealDinner
    
    var revert: MealsType {
        switch self {
        case .breakfast:
            return .mealBreakfast
        case .lunch:
            return .mealLunch
        case .dinner:
            return .mealDinner
        case .mealBreakfast:
            return .breakfast
        case .mealLunch:
            return .lunch
        case .mealDinner:
            return .dinner
        case .none:
            return .none
        }
    }
    
    var text: String {
        switch self {
        case .breakfast:
            return "Завтрак"
        case .lunch:
            return "Обед"
        case .dinner:
            return "Ужин"
        case .none:
            return ""
        case .mealBreakfast:
            return "Блюдо завтрака"
        case .mealLunch:
            return "Блюдо обеда"
        case .mealDinner:
            return "Блюдо ужина"
        }
    }
}

struct Meals {
    var name: String
    var cal: Double
    var checked: Bool
    
    init(mealName: String, calories: Double, check: Bool = false) {
        name = mealName
        cal = calories
        checked = check
    }
}

struct CellInfo {
    var section: Int
    var cellType: MealsType
    var disclosureState: Bool
    var meals: [Meals]
    
    init(_ sec: Int, initType: MealsType) {
        section = sec
        cellType = initType
        disclosureState = false
        meals = []
    }
}

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

    private func changeDisclosure(toState state: Bool, forMeal meal: MealsType, fromSection section: Int) {
        let dataCellIndex = self.indexOfCellData(forMeal: meal, atSection: section)
        cellData[dataCellIndex].disclosureState = state
    }
        
    private func changeMealState(toState state: Bool, atIndex index: Int, forMeal meal: MealsType, fromSection section: Int) {
        let dataCellIndex = self.indexOfCellData(forMeal: meal.revert, atSection: section)
        cellData[dataCellIndex].meals[index].checked = state
    }
    
    private func indexOfCellData(forMeal meal: MealsType, atSection section: Int) -> Int {
        guard let index = cellData.firstIndex(where: { $0.section == section && $0.cellType == meal }) else {
            fatalError("Can't find cell index for \(meal.text)!")
        }
        return index
    }
}

extension DietScreenPresenter: DietScreenModuleInput {
    func setMealList(_ meals: [Meals], day: Int, celltype: MealsType) {
        if (rowInSection.count < day) { return }
        
        // Очистка ячеек из таблицы
        self.uncheckedDiet(mealType: celltype, inSection: day - 1)
        
        // Обновление данных ячейки
        let dataIndex = self.indexOfCellData(forMeal: celltype, atSection: day - 1)
        cellData[dataIndex].meals = meals
        
        // Добавление ячеек с новыми данными
        self.checkedDiet(mealType: celltype, inSection: day - 1)
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
    
    func getNumOfDay() -> Int {
        return numOfSec
    }
    
    func getNumOfRows(inSection section: Int) -> Int {
        if rowInSection.count <= section { return 0 }
        else { return rowInSection[section].count }
    }
}

extension DietScreenPresenter {
    func initCellData() {
        // Add from Model
        numOfSec = 10
        for curSection in 0...numOfSec-1 {
            rowInSection.insert([.breakfast, .lunch, .dinner], at: curSection)
            cellData.append(contentsOf: [
                CellInfo(curSection, initType: .breakfast),
                CellInfo(curSection, initType: .lunch),
                CellInfo(curSection, initType: .dinner)
            ])
        }
    }
    
    // Запрос на обновление данных (Отправитьь запрос в модель)
    func updateMealList(day: Int, mealtype: MealsType) {
        let meal: [Meals] = [Meals(mealName: "first", calories: 400, check: true), Meals(mealName: "second", calories: 300)]
        self.setMealList(meal, day: day, celltype: mealtype)
    }
}

// Обработчики нажатий
extension DietScreenPresenter {
    func checkedDiet(mealType celltype: MealsType, inSection section: Int) {
        print("[DEBUG] \(celltype.text) disclosure at \(section + 1)")
        self.changeDisclosure(toState: true, forMeal: celltype, fromSection: section)
        guard let (cellTypeForRemove, mealDataSize, dietCellIndex, mealIndexPath) = self.prepareCells(mealType: celltype, atSection: section) else {
            return
        }
        rowInSection[section].insert(contentsOf: Array(repeating: cellTypeForRemove, count: mealDataSize), at: dietCellIndex + 1)
        view?.showCells(for: mealIndexPath)
    }
    
    func uncheckedDiet(mealType celltype: MealsType, inSection section: Int) {
        print("[DEBUG] \(celltype.text) closure at \(section + 1)")
        self.changeDisclosure(toState: false, forMeal: celltype, fromSection: section)
        guard let (cellTypeForRemove, _, _, mealIndexPath) = prepareCells(mealType: celltype, atSection: section) else {
            return
        }
        rowInSection[section].removeAll(where: {$0 == cellTypeForRemove})
        view?.hideCells(for: mealIndexPath)
    }
    
    func checkedMeal(atPosition position: Int, forMeal celltype: MealsType, inSection section: Int) {
        print("[DEBUG] \(celltype.text) checked at \(section + 1) day in \(position) position")
        self.changeMealState(toState: true, atIndex: position, forMeal: celltype, fromSection: section)
    }
    
    func uncheckedMeal(atPosition position: Int, forMeal celltype: MealsType, inSection section: Int) {
        print("[DEBUG] \(celltype.text) unchecked at \(section + 1) day in \(position) position")
        self.changeMealState(toState: false, atIndex: position, forMeal: celltype, fromSection: section)
    }
}

extension DietScreenPresenter: DietScreenInteractorOutput {
}
