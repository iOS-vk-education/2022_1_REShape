//
//  LoginScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import Foundation
import FirebaseAuth

final class LoginScreenInteractor {
	weak var output: LoginScreenInteractorOutput?
}

extension LoginScreenInteractor: LoginScreenInteractorInput {
    func rememberUser(isRemembered: Bool, key: String){
        defaults.set(isRemembered, forKey: key)
    }
    
    func checkLogIn(email: String, password: String, completion: @escaping (String?) -> ()) {
        AuthManger.logIn(email: email, password: password) { authDataResult , error in
            guard let error = error else {
                completion(nil)
                return
            }
            if let authError = AuthErrorCode(rawValue: error._code) {
                completion(authError.errorMessage)
            }
        }
    }
}
