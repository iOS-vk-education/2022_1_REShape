//
//  LoginScreenContainer.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import UIKit

final class LoginScreenContainer {
    let input: LoginScreenModuleInput
	let viewController: UIViewController
	private(set) weak var router: LoginScreenRouterInput!

	static func assemble(with context: LoginScreenContext) -> LoginScreenContainer {
        let router = LoginScreenRouter()
        let manager = LoginManager()
        let interactor = LoginScreenInteractor(manager: manager)
        let presenter = LoginScreenPresenter(router: router, interactor: interactor)
		let viewController = LoginScreenViewController(output: presenter)


		presenter.view = viewController
        router.viewController = viewController
        router.window = context.window
        router.fbController = context.fbController
		presenter.moduleOutput = context.moduleOutput
		interactor.output = presenter

        return LoginScreenContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: LoginScreenModuleInput, router: LoginScreenRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct LoginScreenContext {
	weak var moduleOutput: LoginScreenModuleOutput?
    let fbController: FirebaseController
    let window: UIWindow
}
