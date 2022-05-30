//
//  ResultsNetworkManager.swift
//  reshape
//
//  Created by Veronika on 29.05.2022.
//

import Foundation
import Firebase
import UIKit

final class ResultsNetworkManager: ResultsNetworkManagerProtocol {
    private let commonDBRef = Database
        .database(url: "https://reshape-8f528-default-rtdb.europe-west1.firebasedatabase.app/")
        .reference()
        .child("users")
    func getUserData(completion: @escaping (Result<(Data, Int), Error>) -> ()) {
        commonDBRef.child(Auth.auth().currentUser?.uid ?? "").getData { error, snapshot in
            if let error = error {
                completion(.failure(error))
            }
            let userData = snapshot.data ?? Data()
            let startDate = Calendar(identifier: .iso8601).startOfDay(for: Auth.auth().currentUser?.metadata.creationDate ?? Date())
            let currentDay = Int(startDate.distance(to: Date()) / 86400)
            completion(.success((userData, currentDay)))
        }
    }

}
