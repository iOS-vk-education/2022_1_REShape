//
//  RegisterScreenContainer.swift
//  reshape
//
//  Created by Veronika on 04.04.2022.
//  
//

import UIKit

final class RegisterScreenContainer {
    let input: RegisterScreenModuleInput
	let viewController: UIViewController
	private(set) weak var router: RegisterScreenRouterInput!
    


	static func assemble(with context: RegisterScreenContext) -> RegisterScreenContainer {
        let router = RegisterScreenRouter()
        let manager = RegistrationManager()
        let interactor = RegisterScreenInteractor(manager: manager)
        let presenter = RegisterScreenPresenter(router: router, interactor: interactor)
		let viewController = RegisterScreenViewController(output: presenter)
        

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput
        router.viewController = viewController
        router.fbController = context.fbController
		interactor.output = presenter
        router.window = context.window
        return RegisterScreenContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: RegisterScreenModuleInput, router: RegisterScreenRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct RegisterScreenContext {
	weak var moduleOutput: RegisterScreenModuleOutput?
    let fbController: FirebaseController
    let window: UIWindow
}
