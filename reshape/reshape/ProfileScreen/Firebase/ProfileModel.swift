//
//  ProfileModel.swift
//  reshape
//
//  Created by Полина Константинова on 30.05.2022.
//

import Foundation

struct User: Codable {
    let age: String
    let email: String
    let gender: Gender
    let height: String
    let name: String
    let photo: String
    let weight: String?
    let surname: String
    let target: String
    let uid: String
}

enum Gender: String, Codable {
    case man = "муж"
    case woman = "жен"
}
