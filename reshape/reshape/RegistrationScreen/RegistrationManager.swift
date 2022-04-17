//
//  RegistrationManager.swift
//  reshape
//
//  Created by Veronika on 17.04.2022.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import Firebase

final class RegistrationManager{
    
    private let realTimeReference = Database.database().reference().child("users")
    
    func registerUser(photo: Data,
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
        AuthManger.register(email: email, password: password){ (result, error) in
            guard let error = error else {
                if let result = result {
                    self.uploadPhoto(currentUserId: result.user.uid, photo: photo) {[weak self] myresult in
                        switch myresult {
                        case .success(let url):
                            self?.realTimeReference.child(result.user.uid).updateChildValues(["photo": url.absoluteString,
                                                                          "gender": gender,
                                                                          "name": name,
                                                                          "surname": surname,
                                                                          "age": age,
                                                                          "height": height,
                                                                          "weight": weight,
                                                                          "target": target,
                                                                          "email": email,
                                                                          "uid": result.user.uid])
                        case .failure(let error):
                            completion(error.localizedDescription)
                        }
                    }
                }
                completion(nil)
                return
            }
            if let authError = AuthErrorCode(rawValue: error._code) {
                completion(authError.errorMessage)
            }
        }
    }
    func uploadPhoto(currentUserId: String, photo: Data, completion: @escaping (Result<URL, Error>) -> Void){
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
