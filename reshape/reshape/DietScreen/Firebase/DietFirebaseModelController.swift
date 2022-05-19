//
//  DietFirebaseModel.swift
//  reshape
//
//  Created by Иван Фомин on 28.04.2022.
//

import Foundation
import Firebase
import FirebaseDatabase

final class DietFirebaseModelController {
    private var commonDBRef: DatabaseReference = DatabaseReference()
    private var userDBRef: DatabaseReference = DatabaseReference()
    private var commonSnapshot: NSDictionary = [:]
    private var userSnapshot: NSDictionary = [:]
    private var isAuth: Bool = false
    
    init() {
        commonDBRef = Database
            .database(url: "https://reshape-8f528-default-rtdb.europe-west1.firebasedatabase.app/")
            .reference()
            .child("diets")
        isAuth = checkLogin()
    }
    
    private func checkLogin() -> Bool {
        guard isAuth else {
            guard let id = Auth.auth().currentUser?.uid else {
                print("No login")
                return isAuth
            }
            userDBRef = Database.database(url: "https://reshape-8f528-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("users/\(id)")
            isAuth = true
            return isAuth
        }
        return isAuth
    }
    
    // Загрузка индивидуальной информации
    func loadIndividualInfo(completion: @escaping (Error?) -> Void = {_ in return}) {
        // Проверка на авторизацию
        guard checkLogin() else {
            completion(NSError(domain: "No login", code: -10))
            return
        }
        
        userDBRef.getData() { [weak self] error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(error)
                return;
            }
            self?.userSnapshot = snapshot.value as? NSDictionary ?? [:]
            completion(nil)
        }
    }
    
    // Загрузка общего рациона
    func loadCommonInfo(completion: @escaping (Error?) -> Void = {_ in return}) {
        commonDBRef.getData() { [weak self] error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(error)
                return;
            }
            self?.commonSnapshot = snapshot.value as? NSDictionary ?? [:]
            completion(nil)
        }
    }
    
    // Получение блюда по id, дню и приёму пищи
    func getMeal(forID id: Int, forDay day: Int, atMeal meal: String) -> MealStruct {
        // Общая информация о блюде
        let mealDict = (((commonSnapshot["day\(day)"]
                          as? NSDictionary)?["meals"]
                         as? NSDictionary)?[meal]
                        as? NSDictionary)?["meal\(id)"] as? NSDictionary
        let mealName = mealDict?["mealName"] as? String ?? ""
        let mealCal = (mealDict?["mealCalories"] as? NSNumber)?.doubleValue ?? 0
        
        // Состояние нажатия
        let stateDict = ((userSnapshot["days"]
                           as? NSDictionary)?["day\(day)"]
                          as? NSDictionary)?[meal] as? NSDictionary
        let mealState = (stateDict?["meal\(id)"] as? NSNumber)?.boolValue ?? false
        
        // Возврат структуры
        return MealStruct(name: mealName, state: mealState, calories: mealCal)
    }
    
    // Получение числа дней
    func getDaysCount() -> Int {
        return commonSnapshot.count
    }
    
    // Получение числа дней
    func getMealsCount(forDay day: Int, forMeal meal: String) -> Int {
        let mealsDict = ((commonSnapshot["day\(day)"] as? NSDictionary)?["meals"] as? NSDictionary)?[meal] as? NSDictionary
        return mealsDict?.count ?? 0
    }
    
    // Нажатие на блюдо
    func newMealState(_ state: Bool, forDay day: Int, forMeal meal: String, forID id: Int, completion: @escaping ((Error?) -> Void)) {
        // Проверка на авторизацию
        guard checkLogin() else {
            completion(NSError(domain: "No login", code: -10))
            return
        }
        
        // Загрузка данных
        userDBRef.child("days/day\(day)/\(meal)/meal\(id)").setValue(state) { error, _ in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
