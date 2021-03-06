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
    var fbController: FirebaseController?
}

extension RegisterScreenRouter: RegisterScreenRouterInput {
    func backButtonTapped() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    func registerButtonTapped() {
        guard let window = window else { return }
        guard let fbController = fbController else { return }
        let coordinator = MainFlowCoordinator(window: window, firebaseController: fbController)
        coordinator.start()
    }
}
