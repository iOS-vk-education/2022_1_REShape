//
//  WeightFirebaseProtocol.swift
//  reshape
//
//  Created by Иван Фомин on 22.05.2022.
//

import Foundation

protocol WeightFirebaseProtocol {
    // Подгрузка и обновление информации
    func loadIndividualInfo(completion: @escaping (Error?) -> Void)
    func loadCommonInfo(completion: @escaping (Error?) -> Void)
    
    // Получение предварительно подгруженной информации
    func getWeight(forId id: Int) -> WeightStruct
    func getLastWeight() -> String
    func getWeightCount() -> Int
    
    // Отправка новых данных
    func sendNewWeight(forID id: Int, withWeight data: WeightStruct, completion:
                      @escaping (Error?, WeightStruct) -> Void)
}
