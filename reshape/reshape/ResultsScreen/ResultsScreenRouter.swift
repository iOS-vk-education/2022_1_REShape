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
    
    func didWaterTapped() {
        let waterScreenContext = WaterScreenContext(moduleOutput: nil)
        let waterScreenContainer = WaterScreenContainer.assemble(with: waterScreenContext)
        self.viewController?.navigationController?.pushViewController(waterScreenContainer.viewController, animated: true)
    }
    func didWeightTapped() {
        let WeightContext = WeightContext(moduleOutput: nil)
        let WeightContainer = WeightContainer.assemble(with: WeightContext)
        self.viewController?.navigationController?.pushViewController(WeightContainer.viewController, animated: true)
    }
    
    func didCaloriesTapped() {
        self.viewController?.tabBarController?.selectedIndex = 1
    }
    
}
