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
    func endEditing(withWeight weight: Int)
    func cancelEditing()
    
    // Обновление данных
    func reloadData()
}

protocol WeightViewOutput: AnyObject {
    // Навигация
    func backButtonPressed()
    
    // Геттеры для ячеек таблицы
    func getLastWeight() -> Int
    func getLastDate() -> String
    func getLastTime() -> String
    func getCurrentDate() -> String
    func getCurrentTime() -> String
    
    // Геттеры для графика
    func getShortDate(atBackPosition position: Int) -> String
    func getWeight(atBackPosition position: Int) -> Int
    
    // Если изменение подтвердилось
    func uploadNewWeight(newDate date: String, newTime time: String, newWeight weight: Int)
}

protocol WeightInteractorInput: AnyObject {
    // Получение данных о весе для графика из локальной БД
    func getWeightData(atBackPosition position: Int) -> WeightDataModel
    
    // Получение данных о весе для ячеек из локальной БД
    func getLastWeightData() -> WeightDataModel
    
    // Запрос на загрузку изменнногот веса
    func uploadNewWeight(weightData: WeightDataModel)
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
