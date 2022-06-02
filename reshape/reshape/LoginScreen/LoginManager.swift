//
//  LoginManager.swift
//  reshape
//
//  Created by Veronika on 17.04.2022.
//

import Foundation
import FirebaseAuth
import Firebase

final class LoginManager{
    func logIn(email: String, password: String, completion: @escaping (String?) -> ()) {
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
