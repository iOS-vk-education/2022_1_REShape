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
    
    func restorePassword(email: String) {
        manager.resetPassword(email: email){error in
            self.output?.restorePasswordStatus(errorString: error)
            
        }
    }
    
}
