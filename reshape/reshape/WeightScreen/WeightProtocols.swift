//
//  WeightProtocols.swift
//  reshape
//
//  Created by Иван Фомин on 15.04.2022.
//  
//

import Foundation

protocol WeightModuleInput {
	var moduleOutput: WeightModuleOutput? { get }
}

protocol WeightModuleOutput: AnyObject {
}

protocol WeightViewInput: AnyObject {
    // Управление от событий ячеек
    func startEditing()
    func endEditing(withWeight weight: String)
    func cancelEditing()
    
    // Обновление данных
    func reloadData()
    
    // Появление имени
    func updateName()
}

protocol WeightViewOutput: AnyObject {
    // Навигация
    func backButtonPressed()
    
    // Геттеры для ячеек таблицы
    func getLastWeight() -> String
    func getLastDate() -> String
    func getLastTime() -> String
    func getNumOfDays() -> Int
    
    // Геттеры для графика
    func getShortDate(atPosition position: Int) -> String
    func getWeight(atPosition position: Int) -> String
    
    // Получение текущего времени и даты
    func getCurrentDate() -> String
    func getCurrentTime() -> String
    
    // Геттер для имени
    func getName() -> String
    
    // Если изменение подтвердилось
    func uploadNewWeight(newDate date: String, newTime time: String, newWeight weight: String)
    
    // Запрос на загрузку данных из сети
    func requestUploadData()
}

protocol WeightInteractorInput: AnyObject {
    // Получение данных о весе для графика из локальной БД
    func getWeightData(fromPosition position: Int) -> WeightModel?
    
    // Получение количества данных
    func getSize() -> Int
    
    // Получение имени
    func getName() -> String
    
    // Запрос на загрузку изменнного веса
    func uploadNewWeight(_ data: WeightStruct)
    
    // Запрос на загрузку весов из сети
    func getDataFromRemoteBase()
}

protocol WeightInteractorOutput: AnyObject {
    // Сигнал ошибки загрузки
    func undoUploadNewWeight()
    
    // Сигнал появления новых данных
    func newWeightGetting()
    
    // Сигнал о появлении имени
    func nameGetted()
}

protocol WeightRouterInput: AnyObject {
    // Навигация
    func backButtonTapped()
}
