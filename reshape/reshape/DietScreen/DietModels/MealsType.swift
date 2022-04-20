//
//  MealsType.swift
//  reshape
//
//  Created by Иван Фомин on 12.04.2022.
//

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
