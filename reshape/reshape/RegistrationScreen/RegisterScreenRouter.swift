//
//  RegisterScreenRouter.swift
//  reshape
//
//  Created by Veronika on 04.04.2022.
//  
//

import UIKit

final class RegisterScreenRouter {
    var viewController: UIViewController?
    var window: UIWindow?
}

extension RegisterScreenRouter: RegisterScreenRouterInput {
    func backButtonTapped() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
}
