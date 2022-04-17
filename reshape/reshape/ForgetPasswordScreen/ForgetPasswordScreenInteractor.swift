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
    var manager: ForgetPasswordManager?
}

extension ForgetPasswordScreenInteractor: ForgetPasswordScreenInteractorInput {
    
    func restorePassword(email: String, completion: @escaping (String?) -> ()) {
        guard let manager = manager else {
            return
        }
        manager.resetPassword(email: email, completion: completion)
    }
    
}
