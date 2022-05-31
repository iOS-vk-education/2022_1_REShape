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
    weak var firebaseController: ProfileFirebaseProtocol?
    private let manager: ProfileManager?
    
    init(manager: ProfileManager) {
        self.manager = manager
        firebaseController = nil
    }
}

extension ProfileScreenInteractor: ProfileScreenInteractorInput {
        func loadInfo() {
        manager?.getUserData {[weak self] result in
            switch result {
            case .success(let userData):
                let decoder = JSONDecoder()
                guard let decoded = try? decoder.decode(User.self, from: userData) else {
                    return
                }
                self?.output?.didLoadUserData(user: decoded)
            case .failure(let error):
                self?.output?.didCatchError(error: error)
            }
        }
    }
    
    func logOut(){
        manager?.TappedLogOut()
    }
}
