//
//  DisclosureState.swift
//  reshape
//
//  Created by Иван Фомин on 12.04.2022.
//

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
