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
    let manager: ProfileManager
    
    init(manager: ProfileManager) {
        self.manager = manager
    }
}

extension ProfileScreenInteractor: ProfileScreenInteractorInput {
    
    func rememberUser(isRemembered: Bool, key: String) {
        defaults.set(false, forKey: key)
    }
    
    func getDataFromRemoteBase() {
        print("[DEBUG] Запрос на загрузку удаленной БД весов")
        firebaseController?.loadIndividualInfo { [weak self] error in
            // Блок проверок
            guard (error == nil) else { return }
            guard (self != nil) else { return }
            
            self!.output?.informGetted()
        }
    }
    
    func logOut(){
        manager.TappedLogOut()
    }
    
    func getName() -> String {
        return firebaseController?.getName() ?? ""
    }
    
    func getSurname() -> String {
        return firebaseController?.getSurname() ?? ""
    }
    
    func getEmail() -> String {
        return firebaseController?.getEmail() ?? ""
    }
    
    func getTargetWeight() -> String {
        return firebaseController?.getTargetWeight() ?? ""
    }
    
    func getAge() -> String {
        return firebaseController?.getAge() ?? ""
    }
    
    func getHeight() -> String {
        return firebaseController?.getHeight() ?? ""
    }
    
    func getStartWeight() -> String {
        return firebaseController?.getStartWeight() ?? ""
    }
    
    func getGender() -> String {
        return firebaseController?.getGender() ?? ""
    }
    
    func getPhotoURL() -> URL? {
        return firebaseController?.getPhotoURL()
    }
}
