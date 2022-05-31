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
    let userUid = Auth.auth().currentUser?.uid
    
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
    
    func upload(currentUserId: String, photo: Data, completion: @escaping (Result<URL, Error>) -> Void){
        let ref = Storage.storage().reference().child("avatars").child(currentUserId)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        ref.putData(photo, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(url))
            }
        }
    }
}
