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
    func didLoadInfo() {
        interactor.loadInfo()
    }
    
    func quitButtonPressed() {
        router.quitButtonTapped()
    }
    
    func didLogOut(){
        UserDefaults.standard.removeObject(forKey: "isRemembered")
        interactor.logOut()
    }
}

extension ProfileScreenPresenter: ProfileScreenInteractorOutput {
    func didCatchError(error: Error) {
        view?.updateViewWithError(error: error)
    }
    
    func didLoadUserData(user: User) {
        guard let phototUrl = URL(string: user.photo)
        else {
            return
        }
        let viewModel = ProfileModelView(name: user.name,
                                         surname: user.surname,
                                         email: user.email,
                                         targetWeight: user.target,
                                         startWeight: user.weight ?? "",
                                         gender: user.gender.rawValue,
                                         age: user.age,
                                         height: user.height,
                                        photoURL: phototUrl)
        view?.updateViewWithUserData(viewModel: viewModel)
        print(user.name)
        view?.reloadCollectionView()
    }
}
