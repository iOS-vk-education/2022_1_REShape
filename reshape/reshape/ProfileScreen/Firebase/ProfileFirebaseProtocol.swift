//
//  ProfileFirebaseController.swift
//  reshape
//
//  Created by Иван Фомин on 26.05.2022.
//

import Foundation

protocol ProfileFirebaseProtocol: AnyObject {
//     Подгрузка и обновление информации
    func loadIndividualInfo(completion: @escaping (Error?) -> Void)
    func loadCommonInfo(completion: @escaping (Error?) -> Void)
    
    // Получение предварительно подгруженной информации
    // Для верхней панели
    func getCurrentDay() -> Int
    func getName() -> String
    func getSurname() -> String
    func getPhotoURL() -> URL?
    func getEmail() -> String
    
    // Для таблицы
    func getGender() -> String
    func getAge() -> String
    func getHeight() -> String
    func getStartWeight() -> String
    func getTargetWeight() -> String
}
