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
    var firebaseController: ProfileFirebaseProtocol?
}

extension ProfileScreenRouter: ProfileScreenRouterInput {
    func quitButtonTapped() {
        guard let window = window else { return
        }
        guard let firebaseController = firebaseController else { return }
        let coordinator = AuthCoordinator(window: window, firebaseController: firebaseController as! FirebaseController)
        coordinator.start()
    }
}
