//
//  ResultModel.swift
//  reshape
//
//  Created by Veronika on 29.05.2022.
//

import Foundation

struct User: Codable {
    let age, email: String
    let gender: Gender
    let height, name: String
    let photo: String
    let surname, target, uid: String
    let weight: String?
    let calories: [String: Int]?
    let weights: [String: Weight]
    let water: [String: Water]
}

enum Gender: String, Codable {
    case man = "man"
    case woman = "woman"
}

struct Weight: Codable {
    let date, time, weight: String

    enum WaterCodingKeys: String, CodingKey {
        case date = "Date"
        case time = "Time"
        case weight = "Weight"
    }
}

struct Water: Codable {
    let alco, coffe, fizzy, juice, milk, tea, total, water: String
    enum WeightCodingKeys: String, CodingKey {
        case alco = "alco"
        case coffe = "coffe"
        case fizzy = "fizzy"
        case juice = "juice"
        case milk = "milk"
        case tea = "tea"
        case total = "total"
        case water = "water"
    }
}
