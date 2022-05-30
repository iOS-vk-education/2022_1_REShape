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
    func updateInform()
}

protocol ProfileScreenViewOutput: AnyObject {
    func quitButtonPressed()
    func didLogOut()
    func requestUploadData()
    func getEmail() -> String
    func getName() -> String
    func getSurname() -> String
    func getTargetWeight() -> String
    func getStartWeight() -> String
    func getAge() -> String
    func getHeight() -> String
    func getGender() -> String
    func getPhotoURL() -> URL?
}

protocol ProfileScreenInteractorInput: AnyObject {
    func logOut()
    func getDataFromRemoteBase()
    func getName() -> String
    func getSurname() -> String
    func getEmail() -> String
    func getTargetWeight() -> String
    func getStartWeight() -> String
    func getAge() -> String
    func getHeight() -> String
    func getGender() -> String
    func getPhotoURL() -> URL?
}

protocol ProfileScreenInteractorOutput: AnyObject {
    func informGetted()
}

protocol ProfileScreenRouterInput: AnyObject {
    func quitButtonTapped()
}
