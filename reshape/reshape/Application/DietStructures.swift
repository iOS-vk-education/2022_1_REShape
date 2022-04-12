//
//  DietEnums.swift
//  reshape
//
//  Created by Иван Фомин on 11.04.2022.
//

// Disclosure state
enum DisclosureState {
    case disclosure, closure, reload
    
    var revert: DisclosureState {
        switch self {
        case .disclosure:
            return .closure
        case .closure:
            return .disclosure
        default:
            return .reload
        }
    }
}

// Типы ячеек
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

// Структура блюда
struct Meals {
    var name: String
    var cal: Double
    var checked: Bool
    
    init(mealName: String, calories: Double, check: Bool = false) {
        name = mealName
        cal = calories
        checked = check
    }
    
    static func != (lhs: Meals, rhs: Meals) -> Bool {
        if lhs.name != rhs.name {
            return false
        }
        if lhs.cal != rhs.cal {
            return false
        }
        if lhs.checked != rhs.checked {
            return false
        }
        return true
    }
}

// База данных ячейки
class CellInfo {
    var section: Int
    var cellType: MealsType
    var disclosureState: DisclosureState
    var meals: [Meals]
    
    init(_ sec: Int, initType: MealsType) {
        section = sec
        cellType = initType
        disclosureState = .closure
        meals = []
    }
    
    func updateMeals(to meals: [Meals]) {
        self.meals = meals
    }
    
    func changeMealState(atIndex index: Int, toState state: Bool) {
        self.meals[index].checked = state
    }
    
    func changeDisclosure(toState state: DisclosureState) {
        self.disclosureState = state
    }
}
