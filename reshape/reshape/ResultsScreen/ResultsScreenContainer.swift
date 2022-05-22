//
//  ResultsScreenContainer.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import UIKit

final class ResultsScreenContainer {
    let input: ResultsScreenModuleInput
	let viewController: UIViewController

	private(set) weak var router: ResultsScreenRouterInput!

	static func assemble(with context: ResultsScreenContext) -> ResultsScreenContainer {
        let router = ResultsScreenRouter()
        let interactor = ResultsScreenInteractor()
        let presenter = ResultsScreenPresenter(router: router, interactor: interactor)
		let viewController = ResultsScreenViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput
        router.viewController = viewController
        router.window = context.window
        router.firebaseController = context.firebaseController
		interactor.output = presenter
        interactor.firebaseController = context.firebaseController

        return ResultsScreenContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: ResultsScreenModuleInput, router: ResultsScreenRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct ResultsScreenContext {
	weak var moduleOutput: ResultsScreenModuleOutput?
    weak var firebaseController: ResultFirebaseProtocol?
    let window: UIWindow
}
