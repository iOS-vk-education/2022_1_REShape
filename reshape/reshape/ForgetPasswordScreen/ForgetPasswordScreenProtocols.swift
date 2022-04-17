//
//  ForgetPasswordScreenProtocols.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import Foundation

protocol ForgetPasswordScreenModuleInput {
	var moduleOutput: ForgetPasswordScreenModuleOutput? { get }
}

protocol ForgetPasswordScreenModuleOutput: AnyObject {
}

protocol ForgetPasswordScreenViewInput: AnyObject {
    func didRestorePasswordStatusSet(errorString: String?)
}

protocol ForgetPasswordScreenViewOutput: AnyObject {
    func closeForgetPasswordScreen()
    func didRestorePassword(email: String)
}

protocol ForgetPasswordScreenInteractorInput: AnyObject {
    func restorePassword(email: String)
}

protocol ForgetPasswordScreenInteractorOutput: AnyObject {
    func restorePasswordStatus(errorString: String?)
}

protocol ForgetPasswordScreenRouterInput: AnyObject {
    func closeButton()
}
