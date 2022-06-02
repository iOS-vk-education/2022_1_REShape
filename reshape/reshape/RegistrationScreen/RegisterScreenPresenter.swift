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
    func didRegisterUser(photo: Data,
                         gender: String,
                         name: String,
                         surname: String,
                         age: String,
                         height: String,
                         weight: String,
                         target: String,
                         email: String,
                         password: String){
        interactor.register(photo: photo,
                            gender: gender,
                            name: name,
                            surname: surname,
                            age: age,
                            height: height,
                            weight: weight,
                            target: target,
                            email: email,
                            password: password)
                            
    }

    
    func backButtonPressed(){
        router.backButtonTapped()
    }
}

extension RegisterScreenPresenter: RegisterScreenInteractorOutput {
    func registerStatus(errorString: String?) {
        if let errorString = errorString {
            view?.didRegisterStatusSet(errorString: errorString)
        } else {
            router.registerButtonTapped()
        }
    }
    
}
