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
}

protocol ForgetPasswordScreenViewOutput: AnyObject {
    func closeForgetPasswordScreen()
    func didRestorePassword(email: String, completion: @escaping (String?) -> ())
}

protocol ForgetPasswordScreenInteractorInput: AnyObject {
    func restorePassword(email: String, completion: @escaping (String?) -> ())
}

protocol ForgetPasswordScreenInteractorOutput: AnyObject {
}

protocol ForgetPasswordScreenRouterInput: AnyObject {
    func closeButton()
}
