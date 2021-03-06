//
//  DietScreenContainer.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import UIKit

final class DietScreenContainer {
    let input: DietScreenModuleInput
	let viewController: UIViewController
	private(set) weak var router: DietScreenRouterInput!

	static func assemble(with context: DietScreenContext) -> DietScreenContainer {
        let router = DietScreenRouter()
        let interactor = DietScreenInteractor()
        let presenter = DietScreenPresenter(router: router, interactor: interactor)
		let viewController = DietScreenViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter
        interactor.firebaseController = context.firebaseController
        interactor.firebaseController?.dietInteractor = interactor

        return DietScreenContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: DietScreenModuleInput, router: DietScreenRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct DietScreenContext {
	weak var moduleOutput: DietScreenModuleOutput?
    weak var firebaseController: DietFirebaseProtocol?
}
