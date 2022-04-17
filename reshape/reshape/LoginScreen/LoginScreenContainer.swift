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
        let interactor = LoginScreenInteractor()
        let presenter = LoginScreenPresenter(router: router, interactor: interactor)
		let viewController = LoginScreenViewController(output: presenter)
        let manager = LoginManager()

		presenter.view = viewController
        router.viewController = viewController
        router.window = context.window
		presenter.moduleOutput = context.moduleOutput
        interactor.manager = manager
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
    let window: UIWindow
}
