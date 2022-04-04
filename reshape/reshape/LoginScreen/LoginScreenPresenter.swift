//
//  LoginScreenPresenter.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import Foundation

final class LoginScreenPresenter {
	weak var view: LoginScreenViewInput?
    weak var moduleOutput: LoginScreenModuleOutput?
    
	private let router: LoginScreenRouterInput
	private let interactor: LoginScreenInteractorInput
    
    init(router: LoginScreenRouterInput, interactor: LoginScreenInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension LoginScreenPresenter: LoginScreenModuleInput {
}

extension LoginScreenPresenter: LoginScreenViewOutput {
    func closeLoginScreen() {
        router.closeButtonTapped()
    }
    
    func showForgetPasswordScreen() {
        router.forgetPasswordButtonTapped()
    }
    func isUserRemembered(isRemembered: Bool, forKey: String){
        interactor.rememberUser(isRemembered: isRemembered, key: forKey)
    }
    func loginDidTapped() {
        router.didLogged()
    }

}

extension LoginScreenPresenter: LoginScreenInteractorOutput {
}
