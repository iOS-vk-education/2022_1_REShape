//
//  ProfileManager.swift
//  reshape
//
//  Created by Полина Константинова on 01.05.2022.
//

import Foundation
import FirebaseAuth
import Firebase
import UIKit

final class ProfileManager{
    func TappedLogOut(){
        AuthManger.logOut()
    }
    private let commonDBRef = Database
        .database(url: "https://reshape-8f528-default-rtdb.europe-west1.firebasedatabase.app/")
        .reference()
        .child("users")
    func getUserData(completion: @escaping (Result<(Data), Error>) -> ()) {
        commonDBRef.child(Auth.auth().currentUser?.uid ?? "").getData { error, snapshot in
            if let error = error {
                completion(.failure(error))
            }
            
            let userData = snapshot.data ?? Data()
            completion(.success(userData))
        }
    }
}
