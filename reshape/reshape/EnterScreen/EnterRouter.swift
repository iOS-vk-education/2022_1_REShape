//
//  EnterRouter.swift
//  reshape
//
//  Created by Иван Фомин on 18.03.2022.
//  
//

import UIKit

final class EnterRouter {
    var viewController: UIViewController?
    var window: UIWindow?
    var fbController: FirebaseController?
}

extension EnterRouter: EnterRouterInput {
    func enterButtonPressed() {
        guard let window = window else { return }
        guard let fbController = fbController else { return }
         
        let loginScreenContext = LoginScreenContext(moduleOutput: nil, fbController: fbController, window: window)
        let loginScreenContainer = LoginScreenContainer.assemble(with: loginScreenContext)
        loginScreenContainer.viewController.modalPresentationStyle = .overCurrentContext
        self.viewController?.present(loginScreenContainer.viewController, animated: false)
    }
    func signUpTapped() {
        guard let window = window else { return }
        guard let fbController = fbController else { return }
        
        let registerScreenContext = RegisterScreenContext(moduleOutput: nil, fbController: fbController, window: window)
        let registerScreenContainer = RegisterScreenContainer.assemble(with: registerScreenContext)
        self.viewController?.navigationController?.pushViewController(registerScreenContainer.viewController, animated: true)
    }
}
