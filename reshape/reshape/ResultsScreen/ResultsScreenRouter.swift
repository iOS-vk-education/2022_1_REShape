//
//  ResultsScreenRouter.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import UIKit

final class ResultsScreenRouter {
    var viewController: UIViewController?
    var window: UIWindow?
}

extension ResultsScreenRouter: ResultsScreenRouterInput {
    func didCaloriesTapped() {
        self.viewController?.tabBarController?.selectedIndex = 1
    }
}
