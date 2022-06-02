//
//  ForgetPasswordManager.swift
//  reshape
//
//  Created by Veronika on 17.04.2022.
//

import Foundation
import FirebaseAuth

final class ForgetPasswordManager{
    func resetPassword(email: String, completion: @escaping (String?) -> ()){
        AuthManger.restorePassword(email: email){ error in
            guard let error = error else {
                completion(nil)
                return
            }
            if let authError = AuthErrorCode(rawValue: error._code){
                completion(authError.errorMessage)
            }
            
        }
    }
}
