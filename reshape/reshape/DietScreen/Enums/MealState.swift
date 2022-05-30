//
//  MealState.swift
//  reshape
//
//  Created by Иван Фомин on 30.05.2022.
//

enum MealState {
    case checked, unchecked, unavailable, loading
    
    init(_ state: Bool) {
        switch state {
        case false: self = .unchecked
        case true: self = .checked
        }
    }
    
    init(_ number: Int) {
        switch number {
        case 0: self = .unchecked
        case 1: self = .checked
        case 2: self = .unavailable
        case 3: self = .loading
        default: self = .unavailable
        }
    }
    
    var int: Int {
        switch self {
        case .unchecked: return 0
        case .checked: return 1
        case .unavailable: return 2
        case .loading: return 3
        }
    }
}
