//
//  RegisterScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 04.04.2022.
//  
//

import Foundation
import Firebase

final class RegisterScreenInteractor {
    weak var output: RegisterScreenInteractorOutput?
}

extension RegisterScreenInteractor: RegisterScreenInteractorInput {
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
                              completion: @escaping (String?) -> ()){
        AuthManger.register(email: email, password: password){ (result, error) in
            guard let error = error else {
                if let result = result {
                    let ref = Database.database().reference().child("users")
                    ref.child(result.user.uid).updateChildValues(["photo": photo,
                                                                  "gender": gender,
                                                                  "name": name,
                                                                  "surname": surname,
                                                                  "age": age,
                                                                  "height": height,
                                                                  "weight": weight,
                                                                  "target": target,
                                                                  "email": email])
                }
                completion(nil)
                return
            }
            if let authError = AuthErrorCode(rawValue: error._code) {
                completion(authError.errorMessage)
            }
        }
    }
}
