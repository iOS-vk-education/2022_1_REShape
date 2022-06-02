//
//  MealsType.swift
//  reshape
//
//  Created by Иван Фомин on 12.04.2022.
//

enum MealsType {
    case breakfast, lunch, snack, dinner, none,
         mealBreakfast, mealLunch, mealSnack, mealDinner

    init(_ pos: Int) {
        switch pos {
        case 0: self = .breakfast
        case 1: self = .mealBreakfast
        case 2: self = .lunch
        case 3: self = .mealLunch
        case 4: self = .snack
        case 5: self = .mealSnack
        case 6: self = .dinner
        case 7: self = .mealDinner
        default: self = .none
        }
    }
    
    var int: Int {
        switch self {
        case .breakfast:
            return 0
        case .lunch:
            return 2
        case .snack:
            return 4
        case .dinner:
            return 6
        case .none:
            return -1
        case .mealBreakfast:
            return 1
        case .mealLunch:
            return 3
        case .mealSnack:
            return 5
        case .mealDinner:
            return 7
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
        case .snack:
            return .mealSnack
        case .mealSnack:
            return .snack
        }
    }
    
    var engText: String {
        switch self {
        case .breakfast:
            return "breakfast"
        case .lunch:
            return "lunch"
        case .snack:
            return "snack"
        case .dinner:
            return "dinner"
        case .none:
            return ""
        case .mealBreakfast:
            return "mealBreakfast"
        case .mealLunch:
            return "mealLunch"
        case .mealSnack:
            return "mealSnack"
        case .mealDinner:
            return "mealDinner"
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
        case .snack:
            return "Полдник"
        case .mealSnack:
            return "Блюдо полдника"
        }
    }
}
