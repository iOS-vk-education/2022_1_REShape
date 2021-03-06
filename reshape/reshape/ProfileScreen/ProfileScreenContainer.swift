//
//  ProfileScreenContainer.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import UIKit

final class ProfileScreenContainer {
    let input: ProfileScreenModuleInput
	let viewController: UIViewController
	private(set) weak var router: ProfileScreenRouterInput!

	static func assemble(with context: ProfileScreenContext) -> ProfileScreenContainer {
        let router = ProfileScreenRouter()
        let manager = ProfileManager()
        let interactor = ProfileScreenInteractor(manager: manager)
        let presenter = ProfileScreenPresenter(router: router, interactor: interactor)
		let viewController = ProfileScreenViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput
        router.firebaseController = context.firebaseController
    
        router.window = context.window

		interactor.output = presenter
        interactor.firebaseController = context.firebaseController

        return ProfileScreenContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: ProfileScreenModuleInput, router: ProfileScreenRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct ProfileScreenContext {
	weak var moduleOutput: ProfileScreenModuleOutput?
    let firebaseController: ProfileFirebaseProtocol?
    let window: UIWindow
}
