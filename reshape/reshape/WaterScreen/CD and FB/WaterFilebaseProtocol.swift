//
//  WaterFilebaseProtocol.swift
//  reshape
//
//  Created by Иван Фомин on 28.05.2022.
//

import Foundation

protocol WaterFirebaseProtocol: AnyObject {
    // Подгрузка и обновление информации
    func loadIndividualInfo(completion: @escaping (Error?) -> Void)
    func loadCommonInfo(completion: @escaping (Error?) -> Void)
    
    // Получение предварительно подгруженной информации
    func getCurrentWater() -> Double
    func getCurrentWaterData() -> WaterStruct
    
    // Отправка новых данных
    func sendWater(withData data: WaterStruct, completion: @escaping (Error?) -> Void)
}
