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
    func didRegisterUser(photo: Data,
                         gender: String,
                         name: String,
                         surname: String,
                         age: String,
                         height: String,
                         weight: String,
                         target: String,
                         email: String,
                         password: String,
                         completion: @escaping (String?) -> ())
}

protocol RegisterScreenInteractorInput: AnyObject {
    func register(photo: Data,
                  gender: String,
                  name: String,
                  surname: String,
                  age: String,
                  height: String,
                  weight: String,
                  target: String,
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
