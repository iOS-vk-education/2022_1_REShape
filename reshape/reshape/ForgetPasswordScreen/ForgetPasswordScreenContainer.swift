//
//  ForgetPasswordScreenContainer.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import UIKit

final class ForgetPasswordScreenContainer {
    let input: ForgetPasswordScreenModuleInput
	let viewController: UIViewController
	private(set) weak var router: ForgetPasswordScreenRouterInput!

	static func assemble(with context: ForgetPasswordScreenContext) -> ForgetPasswordScreenContainer {
        let router = ForgetPasswordScreenRouter()
        let manager = ForgetPasswordManager()
        let interactor = ForgetPasswordScreenInteractor(manager: manager)
        let presenter = ForgetPasswordScreenPresenter(router: router, interactor: interactor)
		let viewController = ForgetPasswordScreenViewController(output: presenter)


        presenter.view = viewController
        router.viewController = viewController
		presenter.moduleOutput = context.moduleOutput
		interactor.output = presenter

        return ForgetPasswordScreenContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: ForgetPasswordScreenModuleInput, router: ForgetPasswordScreenRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct ForgetPasswordScreenContext {
	weak var moduleOutput: ForgetPasswordScreenModuleOutput?
}
