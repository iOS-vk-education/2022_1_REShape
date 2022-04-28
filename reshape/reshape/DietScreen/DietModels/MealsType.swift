//
//  MealsType.swift
//  reshape
//
//  Created by Иван Фомин on 12.04.2022.
//

enum MealsType {
    case breakfast, lunch, dinner, none,
         mealBreakfast, mealLunch, mealDinner

    init(_ pos: Int) {
        switch pos {
        case 0: self = .breakfast
        case 1: self = .lunch
        case 2: self = .dinner
        case 3: self = .mealBreakfast
        case 4: self = .mealLunch
        case 5: self = .mealDinner
        default: self = .none
        }
    }
    
    var int: Int {
        switch self {
        case .breakfast:
            return 0
        case .lunch:
            return 1
        case .dinner:
            return 2
        case .none:
            return -1
        case .mealBreakfast:
            return 3
        case .mealLunch:
            return 4
        case .mealDinner:
            return 5
        }
    }
    
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
