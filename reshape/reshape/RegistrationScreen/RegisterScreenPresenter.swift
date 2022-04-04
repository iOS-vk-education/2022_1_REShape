//
//  RegisterScreenPresenter.swift
//  reshape
//
//  Created by Veronika on 04.04.2022.
//  
//

import Foundation

final class RegisterScreenPresenter {
	weak var view: RegisterScreenViewInput?
    weak var moduleOutput: RegisterScreenModuleOutput?
    
	private let router: RegisterScreenRouterInput
	private let interactor: RegisterScreenInteractorInput
    
    init(router: RegisterScreenRouterInput, interactor: RegisterScreenInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension RegisterScreenPresenter: RegisterScreenModuleInput {
}

extension RegisterScreenPresenter: RegisterScreenViewOutput {
    func backButtonPressed(){
        router.backButtonTapped()
    }
}

extension RegisterScreenPresenter: RegisterScreenInteractorOutput {
}
