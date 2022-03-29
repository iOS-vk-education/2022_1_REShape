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
}

extension EnterRouter: EnterRouterInput {
    func enterButtonPressed() {
        guard let window = window else {
            return
        }
        let loginScreenContext = LoginScreenContext(moduleOutput: nil, window: window)
        let loginScreenContainer = LoginScreenContainer.assemble(with: loginScreenContext)
        loginScreenContainer.viewController.modalPresentationStyle = .overCurrentContext
        self.viewController?.present(loginScreenContainer.viewController, animated: false)
    }
}
