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
}

protocol ForgetPasswordScreenInteractorInput: AnyObject {
}

protocol ForgetPasswordScreenInteractorOutput: AnyObject {
}

protocol ForgetPasswordScreenRouterInput: AnyObject {
    func closeButtonPressed()
}
