//
//  Coordinator.swift
//  reshape
//
//  Created by Иван Фомин on 18.03.2022.
//

import Foundation
import UIKit

protocol CoordinatorProtocol {
    func start()
}

final class Coordinator: CoordinatorProtocol {
    private let window: UIWindow
    private let EnterViewController =  EnterScreen()
//    private lazy var navigationControllers = Coordinator.makeNavigationControllers()
    init(window: UIWindow) {
        self.window = window
    }
        
    func start() {
//        let navigationControllers = NavControllerType.allCases.compactMap {
//            self.navigationControllers[$0]
//        }
        
        window.rootViewController = EnterViewController
        window.makeKeyAndVisible()
        }
}

//extension Coordinator {
//    fileprivate static func makeNavigationControllers() -> [NavControllerType: UINavigationController] {
//        var result: [NavControllerType: UINavigationController] = [:]
//        NavControllerType.allCases.forEach { navControllerKey in
//            let navigationController = UINavigationController()
//            let navBarAppearance = UINavigationBarAppearance()
//            navBarAppearance.configureWithDefaultBackground()
//            navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
//            let tabBarItem = UITabBarItem(title: navControllerKey.title,
//                                            image: navControllerKey.image,
//                                            tag: navControllerKey.rawValue)
//            navigationController.tabBarItem = tabBarItem
//            result[navControllerKey] = navigationController
//        }
//        return result
//    }
//}
