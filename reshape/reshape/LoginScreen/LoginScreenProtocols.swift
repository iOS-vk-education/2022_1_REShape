//
//  LoginScreenProtocols.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import Foundation

protocol LoginScreenModuleInput {
	var moduleOutput: LoginScreenModuleOutput? { get }
}

protocol LoginScreenModuleOutput: AnyObject {
}

protocol LoginScreenViewInput: AnyObject {
}

protocol LoginScreenViewOutput: AnyObject {
    func showForgetPasswordScreen()
    func closeLoginScreen()
}

protocol LoginScreenInteractorInput: AnyObject {
    func rememberUser(isRemembered: Bool, key: String)
}

protocol LoginScreenInteractorOutput: AnyObject {
}

protocol LoginScreenRouterInput: AnyObject {
    func closeButtonPressed()
    func forgetPasswordButtonPressed()
}

