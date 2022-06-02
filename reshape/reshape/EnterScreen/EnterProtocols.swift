//
//  EnterProtocols.swift
//  reshape
//
//  Created by Иван Фомин on 18.03.2022.
//  
//

import Foundation

protocol EnterModuleInput {
	var moduleOutput: EnterModuleOutput? { get }
}

protocol EnterModuleOutput: AnyObject {
}

protocol EnterViewInput: AnyObject {
}

protocol EnterViewOutput: AnyObject {
    func showLoginScreen()
    func registerUser()
}

protocol EnterInteractorInput: AnyObject {
}

protocol EnterInteractorOutput: AnyObject {
}

protocol EnterRouterInput: AnyObject {
    func enterButtonPressed()
    func signUpTapped()
}

