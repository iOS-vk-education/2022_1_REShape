//
//  Coordinator.swift
//  reshape
//
//  Created by Иван Фомин on 18.03.2022.
//

import Foundation
import UIKit

final class AuthCoordinator: CoordinatorProtocol {
    internal var window: UIWindow
    private lazy var navigationControllers = AuthCoordinator.makeNavigationControllers()
    init(window: UIWindow) {
        self.window = window
    }
        
    func start() {
        setupEnter()
        
        let navControllers = NavControllerType.allCases.compactMap {
            self.navigationControllers[$0]
        }
        
        
        window.rootViewController = navControllers[0]
        window.makeKeyAndVisible()
        }
}

extension AuthCoordinator {
    private func setupEnter() {
        guard let navController = navigationControllers[.enterScreen] else {
            fatalError("No navController")
        }
        let enterContext = EnterContext(moduleOutput: nil)
        let enterContainer = EnterContainer.assemble(with: enterContext)
        navController.setViewControllers([enterContainer.viewController], animated: true)
    }
    
    fileprivate static func makeNavigationControllers() -> [NavControllerType: UINavigationController] {
        var result: [NavControllerType: UINavigationController] = [:]
        NavControllerType.allCases.forEach { navControllerKey in
            let navigationController = UINavigationController()
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithDefaultBackground()
            navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
            result[navControllerKey] = navigationController
        }
        return result
    }
}

fileprivate enum NavControllerType: Int, CaseIterable {
    case enterScreen
}
