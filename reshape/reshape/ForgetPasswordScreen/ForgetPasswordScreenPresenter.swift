//
//  ForgetPasswordScreenPresenter.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import Foundation

final class ForgetPasswordScreenPresenter {
	weak var view: ForgetPasswordScreenViewInput?
    weak var moduleOutput: ForgetPasswordScreenModuleOutput?
    
	private let router: ForgetPasswordScreenRouterInput
	private let interactor: ForgetPasswordScreenInteractorInput
    
    init(router: ForgetPasswordScreenRouterInput, interactor: ForgetPasswordScreenInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension ForgetPasswordScreenPresenter: ForgetPasswordScreenModuleInput {
}

extension ForgetPasswordScreenPresenter: ForgetPasswordScreenViewOutput {
    func didRestorePassword(email: String, completion: @escaping (String?) -> ()) {
        interactor.restorePassword(email: email, completion: completion)
    }
    
    func closeForgetPasswordScreen() {
        router.closeButton()
    }
    
}

extension ForgetPasswordScreenPresenter: ForgetPasswordScreenInteractorOutput {
}
