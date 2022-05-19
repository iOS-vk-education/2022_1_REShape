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
    
    // Если изменение подтвердилось
    func uploadNewWeight(newDate date: String, newTime time: String, newWeight weight: String)
}

protocol WeightInteractorInput: AnyObject {
    // Получение данных о весе для графика из локальной БД
    func getWeightData(fromPosition position: Int) -> WeightModel?
    
    // Получение количества данных
    func getSize() -> Int
    
    // Запрос на загрузку изменнногот веса
    func uploadNewWeight(_ data: WeightStruct)
}

protocol WeightInteractorOutput: AnyObject {
    // Сигнал ошибки загрузки
    func undoUploadNewWeight()
    
    // Сигнал появления новых данных
    func newWeightGetting()
}

protocol WeightRouterInput: AnyObject {
    // Навигация
    func backButtonTapped()
}
