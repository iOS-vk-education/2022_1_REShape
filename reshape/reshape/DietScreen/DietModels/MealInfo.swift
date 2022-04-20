//
//  Meals.swift
//  reshape
//
//  Created by Иван Фомин on 12.04.2022.
//

// Структура ячейки блюда для базы данных
struct MealInfo {
    var name: String
    var cal: Double
    var checked: Bool
    
    init(mealName: String, calories: Double, check: Bool = false) {
        name = mealName
        cal = calories
        checked = check
    }
    
    static func != (lhs: MealInfo, rhs: MealInfo) -> Bool {
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
