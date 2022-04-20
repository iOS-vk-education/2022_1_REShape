//
//  LoginScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import Foundation

final class LoginScreenInteractor {
	weak var output: LoginScreenInteractorOutput?
}

extension LoginScreenInteractor: LoginScreenInteractorInput {
    func rememberUser(isRemembered: Bool, key: String) {
        defaults.set(isRemembered, forKey: key)
    }
}
