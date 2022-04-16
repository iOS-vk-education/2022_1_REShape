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
    func didRegisterUser(photo: String,
                         gender: String,
                         name: String,
                         surname: String,
                         age: Int,
                         height: Double,
                         weight: Double,
                         target: Double,
                         email: String,
                         password: String,
                         completion: @escaping (String?) -> ()) {
        interactor.registerUser(photo: photo,
                                gender: gender,
                                name: name,
                                surname: surname,
                                age: age,
                                height: height,
                                weight: weight,
                                target: target,
                                email: email,
                                password: password,
                                completion: completion)
    }
    
    func registerDidTap() {
        router.registerButtonTapped()
    }
    
    func backButtonPressed(){
        router.backButtonTapped()
    }
}

extension RegisterScreenPresenter: RegisterScreenInteractorOutput {
}
