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
    private var lastSnapshot: NSDictionary = [:]
    
    init() {
        firebaseRef = Database.database(url: "https://reshape-8f528-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    }
    
    func login() {
        AuthManger.logIn(email: "yyyy@bmstu.ru", password: "qwerty") { [weak self] auth, error  in
            guard let error = error else {
                self?.authHandle = Auth.auth().addStateDidChangeListener({ _,_ in return })
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
    
    func getMeals(forDay day: Int, atMeal meal: String, completion: @escaping (UInt) -> Void) {
        firebaseRef.child("diets/day\(day)/meals/\(meal)").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.lastSnapshot = snapshot.value as? NSDictionary ?? [:]
            completion(snapshot.childrenCount)
        });
    }
    
    func daysCount(completion: @escaping (UInt) -> Void) {
        firebaseRef.child("diets").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            completion(snapshot.childrenCount)
        });
    }
    
    func newMealState(_ state: Bool, forDay day: Int, atMeal meal: String, forID id: Int, completion: @escaping (Bool) -> Void) {
        firebaseRef.child("diets/day\(day)/meals/\(meal)/meal\(id)/mealState").setValue(state) { error,_ in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(false)
                return;
            }
            completion(true)
        }
    }
    
    func mealName(forID id: UInt) -> String {
        let mealData = self.lastSnapshot.value(forKey: "meal\(id)") as? NSDictionary
        return mealData?["mealName"] as? String ?? ""
    }
    
    func mealCalories(forID id: UInt) -> Double {
        let mealData = self.lastSnapshot.value(forKey: "meal\(id)") as? NSDictionary
        let cal = mealData?["mealCalories"] as? NSNumber ?? 0
        return cal.doubleValue
    }
    
    func mealState(forID id: UInt) -> Bool {
        let mealData = self.lastSnapshot.value(forKey: "meal\(id)") as? NSDictionary
        let state = mealData?["mealState"] as? NSNumber ?? 0
        return state.boolValue
    }
}
