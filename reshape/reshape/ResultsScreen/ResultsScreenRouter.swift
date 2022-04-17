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
    func didWeightTapped() {
        let WeightContext = WeightContext(moduleOutput: nil)
        let WeightContainer = WeightContainer.assemble(with: WeightContext)
        self.viewController?.navigationController?.pushViewController(WeightContainer.viewController, animated: true)
    }
    
    func didCaloriesTapped() {
        self.viewController?.tabBarController?.selectedIndex = 1
    }
}
