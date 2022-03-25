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
    func isUserRemembered(isRemembered: Bool, forKey: String)
}

protocol LoginScreenInteractorInput: AnyObject {
    func rememberUser(isRemembered: Bool, key: String)
}

protocol LoginScreenInteractorOutput: AnyObject {
}

protocol LoginScreenRouterInput: AnyObject {
    func closeButton()
    func forgetPasswordButton()
}

