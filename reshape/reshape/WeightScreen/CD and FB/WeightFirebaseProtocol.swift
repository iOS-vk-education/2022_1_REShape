//
//  WeightFirebaseProtocol.swift
//  reshape
//
//  Created by Иван Фомин on 22.05.2022.
//

import Foundation

protocol WeightFirebaseProtocol: AnyObject {
    // Подгрузка и обновление информации
    func loadIndividualInfo(completion: @escaping (Error?) -> Void)
    
    // Получение предварительно подгруженной информации
    func getWeight(forId id: Int) -> WeightStruct
    func getCurrentWeight() -> String
    func getWeightCount() -> Int
    func getName() -> String
    
    // Отправка новых данных
    func sendNewWeight(forID id: Int, withWeight data: WeightStruct, completion:
                      @escaping (Error?, WeightStruct) -> Void)
}
