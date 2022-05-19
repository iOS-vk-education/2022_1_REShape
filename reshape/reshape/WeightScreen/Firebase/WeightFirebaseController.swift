//
//  WeightFirebaseController.swift
//  reshape
//
//  Created by Иван Фомин on 15.05.2022.
//


import Foundation
import Firebase
import FirebaseDatabase

final class WeightFirebaseController {
    private var userDBRef: DatabaseReference = DatabaseReference()
    private var userSnapshot: NSDictionary = [:]
    private var isAuth: Bool = false
    
    init() {
        isAuth = checkLogin()
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
                return
            }
            self?.userSnapshot = snapshot.value as? NSDictionary ?? [:]
            completion(nil)
        }
    }
    
    // Получение числа дней в БД
    func getWeightCount() -> Int {
        return userSnapshot.count
    }
    
    // Получение загруженных данных
    func downloadData(forId id: Int) -> WeightStruct {
        let downloadData = userSnapshot["weight\(id)"] as? NSDictionary
        let stringWeight = downloadData?["Weight"] as? String ?? ""
        let stringDate = downloadData?["Date"] as? String ?? ""
        let stringTime = downloadData?["Time"] as? String ?? ""
        return WeightStruct(weight: stringWeight, date: stringDate, time: stringTime)
    }
    
    // Получение последнего веса
    func getLastWeight() -> String {
        var maxID = -1;
        userSnapshot.forEach { dataDict in
            guard let key = dataDict.key as? String else { return }
            guard let currentID = Int(key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else { return }
            maxID = currentID > maxID ? currentID : maxID
        }
        let data = userSnapshot["weight\(maxID)"] as? NSDictionary
        let stringWeight = data?["Weight"] as? String ?? ""
        return stringWeight
    }
    
    // Запись новых данных
    func uploadWeight(forID id: Int, withWeight data: WeightStruct, completion:
                      @escaping (Error?, WeightStruct) -> Void) {
        // Проверка на авторизацию
        guard checkLogin() else {
            completion(NSError(domain: "No login", code: -10), data)
            return
        }
        
        // Компоновка данных
        let dataToUpload: NSDictionary = [
            "Weight": data.weight,
            "Date": data.date,
            "Time": data.time]

        // Отправка данных
        userDBRef.child("weight\(id)").setValue(dataToUpload) { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(error, data)
                return
            }
            completion(nil, data)
        }
    }
}
