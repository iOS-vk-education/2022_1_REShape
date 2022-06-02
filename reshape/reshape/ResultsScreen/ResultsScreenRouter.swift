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
    weak var firebaseController: ResultFirebaseProtocol?
}

extension ResultsScreenRouter: ResultsScreenRouterInput {
    
    func didWaterTapped() {
        let fbController = firebaseController as? WaterFirebaseProtocol
        let waterScreenContext = WaterScreenContext(moduleOutput: nil, firebaseController: fbController)
        let waterScreenContainer = WaterScreenContainer.assemble(with: waterScreenContext)
        self.viewController?.navigationController?.pushViewController(waterScreenContainer.viewController, animated: true)
    }
    func didWeightTapped() {
        let fbController = firebaseController as? WeightFirebaseProtocol
        let WeightContext = WeightContext(moduleOutput: nil, firebaseController: fbController)
        let WeightContainer = WeightContainer.assemble(with: WeightContext)
        self.viewController?.navigationController?.pushViewController(WeightContainer.viewController, animated: true)
    }
    
    func didCaloriesTapped() {
        self.viewController?.tabBarController?.selectedIndex = 1
    }
    
}
