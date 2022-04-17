//
//  WeightRouter.swift
//  reshape
//
//  Created by Иван Фомин on 15.04.2022.
//  
//

import UIKit

final class WeightRouter {
    var viewController: UIViewController?
}

extension WeightRouter: WeightRouterInput {
    func backButtonTapped() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
}
