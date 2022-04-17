//
//  ForgetPasswordScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import Foundation

final class ForgetPasswordScreenInteractor {
	weak var output: ForgetPasswordScreenInteractorOutput?
    let manager: ForgetPasswordManager
    
    init(manager: ForgetPasswordManager){
        self.manager = manager
    }
}

extension ForgetPasswordScreenInteractor: ForgetPasswordScreenInteractorInput {
    
    func restorePassword(email: String, completion: @escaping (String?) -> ()) {
        manager.resetPassword(email: email, completion: completion)
    }
    
}
