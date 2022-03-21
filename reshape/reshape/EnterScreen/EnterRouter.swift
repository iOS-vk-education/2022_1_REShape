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
}

extension EnterRouter: EnterRouterInput {
    func enterButtonPressed() {
        let loginScreenContext = LoginScreenContext(moduleOutput: nil)
        let loginScreenContainer = LoginScreenContainer.assemble(with: loginScreenContext)
        loginScreenContainer.viewController.modalPresentationStyle = .overCurrentContext
        self.viewController?.present(loginScreenContainer.viewController, animated: false)
    }
}
