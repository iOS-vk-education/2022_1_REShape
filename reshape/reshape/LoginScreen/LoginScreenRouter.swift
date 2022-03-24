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
}

extension LoginScreenRouter: LoginScreenRouterInput {
    
    func forgetPasswordButtonPressed() {
        let forgetPasswordScreenContext = ForgetPasswordScreenContext(moduleOutput: nil)
        let forgetPasswordScreenContainer = ForgetPasswordScreenContainer.assemble(with: forgetPasswordScreenContext)
        forgetPasswordScreenContainer.viewController.modalPresentationStyle = .overFullScreen
        self.viewController?.present(forgetPasswordScreenContainer.viewController, animated: false)
    }
    func closeButtonPressed() {
        viewController?.dismiss(animated: true)
    }
    
}
