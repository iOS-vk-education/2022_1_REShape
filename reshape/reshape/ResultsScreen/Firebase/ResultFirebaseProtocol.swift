//
//  ResultFirebaseProtocol.swift
//  reshape
//
//  Created by Иван Фомин on 22.05.2022.
//

import Foundation

protocol ResultFirebaseProtocol: AnyObject {
    // Подгрузка и обновление информации
    func loadIndividualInfo(completion: @escaping (Error?) -> Void)
    func loadCommonInfo(completion: @escaping (Error?) -> Void)
    
    // Получение предварительно подгруженной информации
    func getCurrentDay() -> Int
    func getCurrentCalories() -> Double
    func getTargetCalories() -> Double
    func getCurrentWeight() -> String
    func getTargetWeight() -> String
    func getCurrentWater() -> Double
    func getName() -> String
    func getSurname() -> String
    func getPhotoURL() -> URL?
}
