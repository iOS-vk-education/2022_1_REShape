//
//  WeightContainer.swift
//  reshape
//
//  Created by Иван Фомин on 15.04.2022.
//  
//

import UIKit

final class WeightContainer {
    let input: WeightModuleInput
	let viewController: UIViewController
	private(set) weak var router: WeightRouterInput!

	static func assemble(with context: WeightContext) -> WeightContainer {
        
        let router = WeightRouter()
        let interactor = WeightInteractor()
        let presenter = WeightPresenter(router: router, interactor: interactor)
		let viewController = WeightViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput
        
        router.viewController = viewController

        interactor.output = presenter
        interactor.firebaseController = context.firebaseController

        return WeightContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: WeightModuleInput, router: WeightRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct WeightContext {
	weak var moduleOutput: WeightModuleOutput?
    weak var firebaseController: WeightFirebaseProtocol?
}
