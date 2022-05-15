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
//    private var authHandle: AuthStateDidChangeListenerHandle?
    private var commonDBRef: DatabaseReference
    private var userDBRef: DatabaseReference
    private var commonSnapshot: NSDictionary = [:]
    private var individualSnapshot: NSDictionary = [:]
    private var userID: String
    
    init() {
        let firebaseRef = Database.database(url: "https://reshape-8f528-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        commonDBRef = firebaseRef.child("diets")
        guard let id = Auth.auth().currentUser?.uid else {
            userID = ""
            userDBRef = DatabaseReference()
            print("No login")
            return
        }
        userID = id
        userDBRef = firebaseRef.child("users/\(userID)/days")
    }
    
    private func checkLogin() {
        guard let id = Auth.auth().currentUser?.uid else {
            userID = ""
            userDBRef = DatabaseReference()
            print("No login")
            return
        }
        userID = id
        userDBRef = Database.database(url: "https://reshape-8f528-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("users/\(userID)/days")
    }
    
    // Загрузка индивидуальной информации
    func loadIndividualInfo(completion: @escaping (Error?) -> Void = {_ in return}) {
        checkLogin()
        userDBRef.getData() { [weak self] error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(error)
                return;
            }
            self?.individualSnapshot = snapshot.value as? NSDictionary ?? [:]
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
        checkLogin()
        guard userID != "" else {
            completion(NSError(domain: "No login", code: -10))
            return
        }
        
        // Загрузка данных
        userDBRef.child("day\(day)/\(meal)/meal\(id)/state").setValue(state) { error, _ in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(error)
                return;
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
        let mealData = ((self.individualSnapshot["day\(day)"] as? NSDictionary)?[meal] as? NSDictionary)?["meal\(id)"] as? NSDictionary
        let state = mealData?["state"] as? NSNumber ?? 0
        return state.boolValue
    }
}
