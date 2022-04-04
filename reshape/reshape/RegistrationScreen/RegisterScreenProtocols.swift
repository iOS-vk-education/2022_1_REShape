//
//  RegisterScreenProtocols.swift
//  reshape
//
//  Created by Veronika on 04.04.2022.
//  
//

import Foundation

protocol RegisterScreenModuleInput {
	var moduleOutput: RegisterScreenModuleOutput? { get }
}

protocol RegisterScreenModuleOutput: AnyObject {
}

protocol RegisterScreenViewInput: AnyObject {
}

protocol RegisterScreenViewOutput: AnyObject {
    func backButtonPressed()
}

protocol RegisterScreenInteractorInput: AnyObject {
}

protocol RegisterScreenInteractorOutput: AnyObject {
}

protocol RegisterScreenRouterInput: AnyObject {
    func backButtonTapped()
}
