//
//  WaterScreenRouter.swift
//  reshape
//
//  Created by Полина Константинова on 16.04.2022.
//  
//

import UIKit

final class WaterScreenRouter {
    var viewController: UIViewController?
    var window: UIWindow?
}

extension WaterScreenRouter: WaterScreenRouterInput {
    func waterBackButtonTapped() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
}
