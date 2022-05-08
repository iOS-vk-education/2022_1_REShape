//
//  ProfileScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

final class ProfileScreenInteractor {
	weak var output: ProfileScreenInteractorOutput?
    let manager: ProfileManager
    
    init(manager: ProfileManager) {
        self.manager = manager
    }
}

extension ProfileScreenInteractor: ProfileScreenInteractorInput {
    func rememberUser(isRemembered: Bool, key: String) {
        defaults.set(false, forKey: key)
    }
    
    func logOut(){
        manager.TappedLogOut()
    }
}
