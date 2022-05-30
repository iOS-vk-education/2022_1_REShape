//
//  AuthManger.swift
//  reshape
//
//  Created by Veronika on 15.04.2022.
//

import Foundation
import Firebase
import FirebaseAuth

final class AuthManger{
    static func logIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            completion(authDataResult, error)
        }
    }
    static func register(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            completion(authDataResult, error)
        }
    }
    static func restorePassword(email: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    static func logOut() {
        try? Auth.auth().signOut()
   }
}
