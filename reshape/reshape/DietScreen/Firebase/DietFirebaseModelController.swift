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
    private var commonDBRef: DatabaseReference
    private var userDBRef: DatabaseReference
    private var commonSnapshot: NSDictionary = [:]
    private var userSnapshot: NSDictionary = [:]
    private var isAuth: Bool
    
    init() {
        let firebaseRef = Database.database(url: "https://reshape-8f528-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        commonDBRef = firebaseRef.child("diets")
        guard let id = Auth.auth().currentUser?.uid else {
            isAuth = false
            userDBRef = DatabaseReference()
            print("No login")
            return
        }
        isAuth = true
        userDBRef = firebaseRef.child("users/\(id)/days")
    }
    
    private func checkLogin() -> Bool {
        guard isAuth else {
            guard let id = Auth.auth().currentUser?.uid else {
                print("No login")
                return isAuth
            }
            userDBRef = Database.database(url: "https://reshape-8f528-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("users/\(id)/weights")
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
    
    // Загрузка блюд для дня
    func getMeals(forDay day: Int, atMeal meal: String, completion: @escaping (UInt, Error?) -> Void) {
        commonDBRef.child("day\(day)/meals/\(meal)").getData() { [weak self] error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(0, error)
                return;
            }
            self?.commonSnapshot = snapshot.value as? NSDictionary ?? [:]
            completion(snapshot.childrenCount, nil)
        }
    }
    
    // Подсчет числа дней
    func daysCount(completion: @escaping (UInt, Error?) -> Void) {
        commonDBRef.getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(0, error)
                return
            }
            completion(snapshot.childrenCount, nil)
        });
    }
    
    // Нажатие на блюдо
    func newMealState(_ state: Bool, forDay day: Int, forMeal meal: String, forID id: Int, withCalories cal: Double, completion: @escaping ((Error?) -> Void)) {
        // Проверка на авторизацию
        guard checkLogin() else {
            completion(NSError(domain: "No login", code: -10))
            return
        }
        
        // Загрузка данных
        userDBRef.child("day\(day)/\(meal)/meal\(id)/state").setValue(state) { error, _ in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(error)
                return
            }
            completion(nil)
        }
        
        // Обновление данных
        loadIndividualInfo()
    }
    
    func mealName(forID id: UInt) -> String {
        let mealData = self.commonSnapshot.value(forKey: "meal\(id)") as? NSDictionary
        return mealData?["mealName"] as? String ?? ""
    }
    
    func mealCalories(forID id: UInt) -> Double {
        let mealData = self.commonSnapshot.value(forKey: "meal\(id)") as? NSDictionary
        let cal = mealData?["mealCalories"] as? NSNumber ?? 0
        return cal.doubleValue
    }
    
    func mealState(forDay day: Int, atMeal meal: String, forID id: UInt) -> Bool {
        let mealData = ((self.userSnapshot["day\(day)"] as? NSDictionary)?[meal] as? NSDictionary)?["meal\(id)"] as? NSDictionary
        let state = mealData?["state"] as? NSNumber ?? 0
        return state.boolValue
    }
}
