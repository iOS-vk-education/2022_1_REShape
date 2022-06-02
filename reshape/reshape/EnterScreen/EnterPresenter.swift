//
//  EnterPresenter.swift
//  reshape
//
//  Created by Иван Фомин on 18.03.2022.
//  
//

import Foundation

final class EnterPresenter {
	weak var view: EnterViewInput?
    weak var moduleOutput: EnterModuleOutput?
    
	private let router: EnterRouterInput
	private let interactor: EnterInteractorInput
    
    init(router: EnterRouterInput, interactor: EnterInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension EnterPresenter: EnterModuleInput {

}

extension EnterPresenter: EnterViewOutput {
    func showLoginScreen() {
        router.enterButtonPressed()
    }
    func registerUser() {
        router.signUpTapped()
    }
}

extension EnterPresenter: EnterInteractorOutput {
}

