//
//  DietFirebaseProtocol.swift
//  reshape
//
//  Created by Иван Фомин on 22.05.2022.
//

import Foundation

protocol DietFirebaseProtocol: AnyObject {
    // Подгрузка и обновление информации
    func loadIndividualInfo(completion: @escaping (Error?) -> Void)
    func loadCommonInfo(completion: @escaping (Error?) -> Void)
    
    // Получение предварительно подгруженной информации
    func getCurrentDay() -> Int
    func getDaysCount() -> Int
    func getCurrentCalories() -> Double
    func getTargetCalories() -> Double
    func getMeal(forID id: Int, forDay day: Int, atMeal meal: String) -> MealStruct
    func getMealsCount(forDay day: Int, forMeal meal: String) -> Int
    
    // Отправка новых данных
    func sendMealAndCalState(mealState state: Bool, calories cal: Double, forDay day: Int, forMeal meal: String, forID id: Int, completion: @escaping ((Error?) -> Void))
}
