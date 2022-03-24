//
//  SceneDelegate.swift
//  reshape
//
//  Created by Андрей Суханов on 17.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: CoordinatorProtocol?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        window = UIWindow(windowScene: windowScene)
        guard let window = window else {
            return
        }
        window.overrideUserInterfaceStyle = .light
        let bool = false
        if bool {
            coordinator = AppCoordinator(window: window, instructor: .authorization)
        } else {
            coordinator = AppCoordinator(window: window, instructor: .main)
        }
        coordinator?.start()
    }
}

