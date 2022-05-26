//
//  DisclosureState.swift
//  reshape
//
//  Created by Иван Фомин on 12.04.2022.
//

enum DisclosureState {
    case disclosure, closure, reload
    
    init(_ state: Bool) {
        switch state {
        case true: self = .disclosure
        case false: self = .closure
        }
    }
    
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
    
    var boolType: Bool {
        switch self {
        case .disclosure:
            return true
        case .closure:
            return false
        case .reload:
            return false
        }
    }
}
