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
    var fbController: FirebaseController?
}

extension LoginScreenRouter: LoginScreenRouterInput {
    
    func forgetPasswordButtonTapped() {
        let forgetPasswordScreenContext = ForgetPasswordScreenContext(moduleOutput: nil)
        let forgetPasswordScreenContainer = ForgetPasswordScreenContainer.assemble(with: forgetPasswordScreenContext)
        forgetPasswordScreenContainer.viewController.modalPresentationStyle = .overFullScreen
        self.viewController?.present(forgetPasswordScreenContainer.viewController, animated: false)
    }
    func closeButtonTapped() {
        viewController?.dismiss(animated: true)
    }
    func didLogged() {
        guard let window = window else { return }
        guard let fbController = fbController else { return }
        let coordinator = MainFlowCoordinator(window: window, firebaseController: fbController)
        coordinator.start()
    }
    
}
