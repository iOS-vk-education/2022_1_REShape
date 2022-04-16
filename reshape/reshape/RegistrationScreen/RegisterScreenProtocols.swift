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
    func registerDidTap()
    func didRegisterUser(photo: String,
                         gender: String,
                         name: String,
                         surname: String,
                         age: Int,
                         height: Double,
                         weight: Double,
                         target: Double,
                         email: String,
                         password: String,
                         completion: @escaping (String?) -> ())
}

protocol RegisterScreenInteractorInput: AnyObject {
    func registerUser(photo: String,
                              gender: String,
                              name: String,
                              surname: String,
                              age: Int,
                              height: Double,
                              weight: Double,
                              target: Double,
                              email: String,
                              password: String,
                              completion: @escaping (String?) -> ())
}

protocol RegisterScreenInteractorOutput: AnyObject {
}

protocol RegisterScreenRouterInput: AnyObject {
    func backButtonTapped()
    func registerButtonTapped()
}
