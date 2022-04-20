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
        guard let window = window else {
            return
    }
        let waterScreenContext = WaterScreenContext(moduleOutput: nil, window: window)
        let waterScreenContainer = WaterScreenContainer.assemble(with: waterScreenContext)
        waterScreenContainer.viewController.modalPresentationStyle = .overCurrentContext
        self.viewController?.navigationController?.pushViewController(waterScreenContainer.viewController, animated: true)
    }
    
    func didCaloriesTapped() {
        self.viewController?.tabBarController?.selectedIndex = 1
    }
   
}
