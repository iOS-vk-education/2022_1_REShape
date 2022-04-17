//
//  RegisterScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 04.04.2022.
//  
//

import Foundation




final class RegisterScreenInteractor {
    weak var output: RegisterScreenInteractorOutput?
    var manager: RegistrationManager?
}

extension RegisterScreenInteractor: RegisterScreenInteractorInput {
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
                  completion: @escaping (String?) -> ()){
        guard let manager = manager else {
            return
        }
        manager.registerUser(photo: photo,
                              gender: gender,
                              name: name,
                              surname: surname,
                              age: age,
                              height: height,
                              weight: weight,
                              target: target,
                              email: email,
                              password: password,
                              completion: completion)
    }
}
