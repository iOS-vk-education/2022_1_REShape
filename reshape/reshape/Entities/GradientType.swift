//
//  GradietType.swift
//  reshape
//
//  Created by Иван Фомин on 20.04.2022.
//

import UIKit

enum GradientType {
    case mainDiagonal, revertMainDiagonal, additDiagonal, revertadditDiagonal, topToDown, downToTop, leftToRight, rightToLeft
    
    var start: CGPoint {
        switch self {
        case .mainDiagonal:
            return CGPoint(x: 0, y: 0)
        case .revertMainDiagonal:
            return CGPoint(x: 1, y: 1)
        case .additDiagonal:
            return CGPoint(x: 1, y: 0)
        case .revertadditDiagonal:
            return CGPoint(x: 0, y: 1)
        case .topToDown:
            return CGPoint(x: 0.5, y: 0)
        case .downToTop:
            return CGPoint(x: 0.5, y: 1)
        case .leftToRight:
            return CGPoint(x: 0, y: 0.5)
        case .rightToLeft:
            return CGPoint(x: 1, y: 0.5)
        }
    }
    
    var end: CGPoint {
        switch self {
        case .mainDiagonal:
            return CGPoint(x: 1, y: 1)
        case .revertMainDiagonal:
            return CGPoint(x: 0, y: 0)
        case .additDiagonal:
            return CGPoint(x: 0, y: 1)
        case .revertadditDiagonal:
            return CGPoint(x: 1, y: 0)
        case .topToDown:
            return CGPoint(x: 0.5, y: 1)
        case .downToTop:
            return CGPoint(x: 0.5, y: 0)
        case .leftToRight:
            return CGPoint(x: 1, y: 0.5)
        case .rightToLeft:
            return CGPoint(x: 0, y: 0.5)
        }
    }
}
