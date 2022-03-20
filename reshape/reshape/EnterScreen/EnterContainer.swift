//
//  EnterContainer.swift
//  reshape
//
//  Created by Иван Фомин on 18.03.2022.
//  
//

import UIKit

final class EnterContainer {
    let input: EnterModuleInput
	let viewController: UIViewController
	private(set) weak var router: EnterRouterInput!

	static func assemble(with context: EnterContext) -> EnterContainer {
        let router = EnterRouter()
        let interactor = EnterInteractor()
        let presenter = EnterPresenter(router: router, interactor: interactor)
		let viewController = EnterViewController(output: presenter)

		presenter.view = viewController
        router.viewController = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter

        return EnterContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: EnterModuleInput, router: EnterRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct EnterContext {
	weak var moduleOutput: EnterModuleOutput?
}
