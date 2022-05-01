//
//  ProfileScreenRouter.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import UIKit

final class ProfileScreenRouter {
    var window: UIWindow?
}

extension ProfileScreenRouter: ProfileScreenRouterInput {
    func quitButtonTapped() {
        guard let window = window else {
            return
        }
        let coordinator = AuthCoordinator(window: window)
        coordinator.start()
    }
}
