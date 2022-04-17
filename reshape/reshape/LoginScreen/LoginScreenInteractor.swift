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
    var manager: LoginManager?
}

extension LoginScreenInteractor: LoginScreenInteractorInput {
    func checkLogIn(email: String, password: String, completion: @escaping (String?) -> ()) {
        guard let manager = manager else {
            return
        }
        manager.logIn(email: email, password: password, completion: completion)
    }
    
    func rememberUser(isRemembered: Bool, key: String){
        defaults.set(isRemembered, forKey: key)
    }
    
    
}
