//
//  AppCoordinator.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//

import Foundation
import UIKit



final class AppCoordinator: CoordinatorProtocol{
    internal var window: UIWindow
    private var instructor: LaunchInstructor
    private var fbController: FirebaseController
    init (window: UIWindow, instructor: LaunchInstructor) {
        self.window = window
        self.instructor = instructor
        self.fbController = FirebaseController()
    }
    
    func start() {
        switch instructor {
        case .authorization:
            performAuthorizationFlow()
        case .main:
            performMainFlow()
        }
    }
    
    enum LaunchInstructor {
        case authorization, main
    }
}
extension AppCoordinator{

    private func performAuthorizationFlow(){
        let coordinator = AuthCoordinator(window: window, firebaseController: fbController)
        coordinator.start()
    }
    private func performMainFlow(){
        let coordinator = MainFlowCoordinator(window: window, firebaseController: fbController)
        coordinator.start()
    }

}
