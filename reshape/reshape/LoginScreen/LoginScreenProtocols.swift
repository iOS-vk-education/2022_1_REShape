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
    func loginDidTapped()
    func didCheckLogin(email: String, password: String, completion: @escaping (String?) -> ())
}

protocol LoginScreenInteractorInput: AnyObject {
    func rememberUser(isRemembered: Bool, key: String)
    func checkLogIn(email: String, password: String, completion: @escaping (String?) -> ())
}

protocol LoginScreenInteractorOutput: AnyObject {
}

protocol LoginScreenRouterInput: AnyObject {
    func closeButtonTapped()
    func forgetPasswordButtonTapped()
    func didLogged()
}

