//
//  ProfileScreenProtocols.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

protocol ProfileScreenModuleInput {
	var moduleOutput: ProfileScreenModuleOutput? { get }
}

protocol ProfileScreenModuleOutput: AnyObject {
}

protocol ProfileScreenViewInput: AnyObject {
    func reloadCollectionView()
    func updateViewWithUserData(viewModel: ProfileModelView)
    func updateViewWithError(error: Error)
}

protocol ProfileScreenViewOutput: AnyObject {
    func quitButtonPressed()
    func didLogOut()
    func didLoadInfo()
    func loadPhoto(photo: Data)
}

protocol ProfileScreenInteractorInput: AnyObject {
    func didUploadPhoto(imageData: Data)
    func logOut()
    func loadInfo()
}

protocol ProfileScreenInteractorOutput: AnyObject {
    func didLoadUserData(user: User)
    func didCatchError(error: Error)
}

protocol ProfileScreenRouterInput: AnyObject {
    func quitButtonTapped()
}
