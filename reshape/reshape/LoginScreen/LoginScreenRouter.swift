//
//  LoginScreenRouter.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import UIKit

final class LoginScreenRouter {
    var viewController: UIViewController?
    var window: UIWindow?
}

extension LoginScreenRouter: LoginScreenRouterInput {
    
    func forgetPasswordButton() {
        let forgetPasswordScreenContext = ForgetPasswordScreenContext(moduleOutput: nil)
        let forgetPasswordScreenContainer = ForgetPasswordScreenContainer.assemble(with: forgetPasswordScreenContext)
        forgetPasswordScreenContainer.viewController.modalPresentationStyle = .overFullScreen
        self.viewController?.present(forgetPasswordScreenContainer.viewController, animated: false)
    }
    func closeButton() {
        viewController?.dismiss(animated: true)
    }
    func loginButton() {
        guard let window = window else {
            return
        }
        let coordinator = MainFlowCoordinator(window: window)
        coordinator.start()
    }
    
}
