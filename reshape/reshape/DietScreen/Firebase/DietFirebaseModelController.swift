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
    private var authHandle: AuthStateDidChangeListenerHandle?
    private var firebaseRef: DatabaseReference
    private var commonSnapshot: NSDictionary = [:]
    private var individualSnapshot: NSDictionary = [:]
    private var userID: String = ""
    
    init() {
        firebaseRef = Database.database(url: "https://reshape-8f528-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    }
    
    func login() {
        AuthManger.logIn(email: "yyyy@bmstu.ru", password: "qwerty") { [weak self] auth, error in
            guard let error = error else {
                self?.authHandle = Auth.auth().addStateDidChangeListener({ _,_ in return })
                self?.userID = Auth.auth().currentUser?.uid ?? ""
                return
            }
            print("[ERROR] \(error.localizedDescription)")
        }
    }
    
    deinit {
        if authHandle != nil {
            Auth.auth().removeStateDidChangeListener(authHandle!)
        }
    }
    
    // Загрузка индивидуальной информации
    func loadIndividualInfo(completion: @escaping ((Error?) -> Void) = { _ in return }) {
        firebaseRef.child("users/\(userID)/days").getData() { [weak self] error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(error)
                return;
            }
            self?.individualSnapshot = snapshot.value as? NSDictionary ?? [:]
            completion(error)
        }
    }
    
    // Загрузка блюд для дня
    func getMeals(forDay day: Int, atMeal meal: String, completion: @escaping (UInt) -> Void) {
        firebaseRef.child("diets/day\(day)/meals/\(meal)").getData() { [weak self] error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            self?.commonSnapshot = snapshot.value as? NSDictionary ?? [:]
            completion(snapshot.childrenCount)
        }
    }
    
    // Подсчет числа дней
    func daysCount(completion: @escaping (UInt) -> Void) {
        firebaseRef.child("diets").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            completion(snapshot.childrenCount)
        });
    }
    
    // Нажатие на блюдо
    func newMealState(_ state: Bool, forDay day: Int, forMeal meal: String, forID id: Int, withCalories cal: Double, completion: @escaping (() -> Void) = { return }) {
        // Загрузка данных
        firebaseRef.child("users/\(userID)/days/day\(day)/\(meal)/meal\(id)/state").setValue(state) { error,_ in
            guard error == nil else {
                print(error!.localizedDescription)
                completion()
                return;
            }
            self.firebaseRef.child("users/\(self.userID)/days/day\(day)/currentCalories").setValue(cal) { error,_ in
                // Обновление
                self.loadIndividualInfo()
                guard error == nil else {
                    print(error!.localizedDescription)
                    completion()
                    return;
                }
            }
        }
        
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
