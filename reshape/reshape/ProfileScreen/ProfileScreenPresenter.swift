//
//  ProfileScreenPresenter.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

final class ProfileScreenPresenter {
	weak var view: ProfileScreenViewInput?
    weak var moduleOutput: ProfileScreenModuleOutput?
    
	private let router: ProfileScreenRouterInput
	private let interactor: ProfileScreenInteractorInput
    
    init(router: ProfileScreenRouterInput, interactor: ProfileScreenInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension ProfileScreenPresenter: ProfileScreenModuleInput {
}

extension ProfileScreenPresenter: ProfileScreenViewOutput {
    func quitButtonPressed() {
        router.quitButtonTapped()
    }
    
    func didLogOut(){
        interactor.logOut()
    }
    
    func requestUploadData() {
        interactor.getDataFromRemoteBase()
    }
    
    func getEmail() -> String {
        return interactor.getEmail()
    }
    
    func getName() -> String {
        return interactor.getName()
    }
    
    func getSurname() -> String {
        return interactor.getSurname()
    }
    
    func getTargetWeight() -> String {
        return interactor.getTargetWeight()
    }
    
    func getStartWeight() -> String {
        return interactor.getStartWeight()
    }
    
    func getAge() -> String {
        return interactor.getAge()
    }
    
    func getHeight() -> String {
        return interactor.getHeight()
    }
    
    func getGender() -> String {
        return interactor.getGender()
    }
    
    func getPhotoURL() -> URL? {
        return interactor.getPhotoURL()
    }
}

extension ProfileScreenPresenter: ProfileScreenInteractorOutput {
    func informGetted() {
        view?.updateInform()
    }
}
