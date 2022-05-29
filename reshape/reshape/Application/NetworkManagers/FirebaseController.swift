//
//  DietFirebaseModel.swift
//  reshape
//
//  Created by Иван Фомин on 28.04.2022.
//

import Foundation
import Firebase
import FirebaseDatabase

final class FirebaseController {
    private var commonDBRef: DatabaseReference = DatabaseReference()
    private var userDBRef: DatabaseReference = DatabaseReference()
    private var commonSnapshot: NSDictionary = [:]
    private var userSnapshot: NSDictionary = [:]
    private var isAuth: Bool = false
    private var currentDay: Int = -1
    private var name: String?
    private var surname: String?
    
    init() {
        commonDBRef = Database
            .database(url: "https://reshape-8f528-default-rtdb.europe-west1.firebasedatabase.app/")
            .reference()
            .child("diets")
        isAuth = checkLogin()
    }
    
    private func checkLogin() -> Bool {
        guard let user = Auth.auth().currentUser else {
            print("No login")
            isAuth = false
            return isAuth
        }
        
        // Ссылка на пользователя
        isAuth = true
        userDBRef = Database.database(url: "https://reshape-8f528-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("users/\(user.uid)")
        
        // Текущий день
        let startDate = Calendar(identifier: .iso8601).startOfDay(for: user.metadata.creationDate ?? Date())
        currentDay = Int(startDate.distance(to: Date()) / 86400)
        return isAuth
    }
}

extension FirebaseController: DietFirebaseProtocol {
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
            self?.name = self?.userSnapshot["name"] as? String
            self?.surname = self?.userSnapshot["surname"] as? String
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
    
    func getCurrentDay() -> Int {
        guard currentDay != -1 else { return -1 }
        guard getDaysCount() != 0 else { return -1 }
        return currentDay % getDaysCount()
    }
    
    // Получение текущих калорий
    func getCurrentCalories() -> Double {
        let day = getCurrentDay()
        let current = ((userSnapshot["calories"]
                        as? NSDictionary)?["day\(day)"]
                       as? NSNumber)?.doubleValue ?? 0
        return current
    }
    
    // Получение целевых калорий
    func getTargetCalories() -> Double {
        let day = getCurrentDay()
        let target = ((commonSnapshot["day\(day)"]
                       as? NSDictionary)?["dayCalories"]
                      as? NSNumber)?.doubleValue ?? 0
        return target
    }
    
    // Получение числа дней
    func getDaysCount() -> Int {
        return commonSnapshot.count
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
    func getMealsCount(forDay day: Int, forMeal meal: String) -> Int {
        let mealsDict = ((commonSnapshot["day\(day)"] as? NSDictionary)?["meals"] as? NSDictionary)?[meal] as? NSDictionary
        return mealsDict?.count ?? 0
    }
    
    // Отправка нового состояния блюда и полученные за день калории
    func sendMealAndCalState(mealState state: Bool, calories cal: Double, forDay day: Int, forMeal meal: String, forID id: Int, completion: @escaping ((Error?) -> Void)) {
        // Проверка на авторизацию
        guard checkLogin() else {
            completion(NSError(domain: "No login", code: -10))
            return
        }
        
        // Флаги загрузок
        var calUpload: Bool = false
        var stateUpload: Bool = false
        
        // Загрузка состояния блюда
        userDBRef.child("days/day\(day)/\(meal)/meal\(id)").setValue(state) { error, _ in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(error)
                return
            }
            stateUpload = true
            if (stateUpload && calUpload) {
                completion(nil)
            }
        }
        // Загрузка калорий
        userDBRef.child("calories/day\(day)").setValue(cal) { error, _ in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(error)
                return
            }
            calUpload = true
            if (stateUpload && calUpload) {
                completion(nil)
            }
        }
    }
}

extension FirebaseController: WeightFirebaseProtocol {
    func getName() -> String {
        return name ?? ""
    }
    
    // Получение всех данных о весе
    func getWeight(forId id: Int) -> WeightStruct {
        let downloadData = ((userSnapshot["weights"]
                             as? NSDictionary)?["weight\(id)"]
                            as? NSDictionary)
        let stringWeight = downloadData?["Weight"] as? String ?? ""
        let stringDate = downloadData?["Date"] as? String ?? ""
        let stringTime = downloadData?["Time"] as? String ?? ""
        return WeightStruct(weight: stringWeight, date: stringDate, time: stringTime)
    }
    
    // Получениие последнего веса
    func getCurrentWeight() -> String {
        // Получение ID последнего знаечния веса
        var maxID = -1;
        userSnapshot.forEach { dataDict in
            guard let key = dataDict.key as? String else { return }
            guard let currentID = Int(key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else { return }
            maxID = currentID > maxID ? currentID : maxID
        }
        
        // Получение последнего знаечния веса
        let data = ((userSnapshot["weights"]
                     as? NSDictionary)?["weight\(maxID)"]
                    as? NSDictionary)
        let stringWeight = data?["Weight"] as? String ?? ""
        return stringWeight
    }
    
    // Число данных веса
    func getWeightCount() -> Int {
        let weights = userSnapshot["weights"] as? NSDictionary
        return weights?.count ?? 0
    }
    
    // Отправка нового веса
    func sendNewWeight(forID id: Int, withWeight data: WeightStruct, completion: @escaping (Error?, WeightStruct) -> Void) {
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
        userDBRef.child("weights/weight\(id)").setValue(dataToUpload) { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(error, data)
                return
            }
            completion(nil, data)
        }
    }
}

extension FirebaseController: ResultFirebaseProtocol {
    func getPhotoURL() -> URL? {
        guard let photoURL = userSnapshot["photo"] as? String else { return nil }
        return URL(string: photoURL)
    }
    
    func getSurname() -> String {
        return surname ?? ""
    }
    
    func getTargetWeight() -> String {
        let target = userSnapshot["target"] as? String
        return target ?? ""
    }
    
    func getCurrentWater() -> Double {
        let day = currentDay
        let water = ((userSnapshot["water"]
                      as? NSDictionary)?["water\(day)"]
                     as? NSDictionary)?["total"] as? NSNumber
        return water?.doubleValue ?? 0
    }
}

extension FirebaseController: ProfileFirebaseProtocol {
    func getGender() -> String {
        let gender = userSnapshot["gender"] as? String
        if gender == "man" {
            return "муж"
        } else if gender == "woman" {
            return "жен"
        } else {
            return ""
        }
    }
    
    func getAge() -> String {
        let age = userSnapshot["age"] as? String
        return age ?? ""
    }
    
    func getHeight() -> String {
        let height = userSnapshot["height"] as? String
        return height ?? ""
    }
    
    func getStartWeight() -> String {
        let weight = getWeight(forId: 0)
        return weight.weight
    }
}

extension FirebaseController: WaterFirebaseProtocol {
    func getCurrentWaterData() -> WaterStruct {
        let id = currentDay
        guard let dict = (userSnapshot["water"]
                          as? NSDictionary)?["water\(id)"] as? NSDictionary else {
            return WaterStruct()
        }
        let waterStruct = WaterStruct(water: (dict["water"] as? NSNumber)?.intValue ?? 0,
                                      coffee: (dict["coffee"] as? NSNumber)?.intValue ?? 0,
                                      tea: (dict["tea"] as? NSNumber)?.intValue ?? 0,
                                      fizzy: (dict["fizzy"] as? NSNumber)?.intValue ?? 0,
                                      milk: (dict["milk"] as? NSNumber)?.intValue ?? 0,
                                      alcohol: (dict["alco"] as? NSNumber)?.intValue ?? 0,
                                      juice: (dict["juice"] as? NSNumber)?.intValue ?? 0
        )
        return waterStruct
    }
    
    func sendWater(withData data: WaterStruct, completion: @escaping (Error?) -> Void) {
        // Проверка на авторизацию
        guard checkLogin() else {
            completion(NSError(domain: "No login", code: -10))
            return
        }
        
        let id = currentDay
        let dict = NSDictionary(dictionary: [
            "water": NSNumber(integerLiteral: data.water),
            "coffee": NSNumber(integerLiteral: data.coffee),
            "tea": NSNumber(integerLiteral: data.tea),
            "fizzy": NSNumber(integerLiteral: data.fizzy),
            "milk": NSNumber(integerLiteral: data.milk),
            "alco": NSNumber(integerLiteral: data.alcohol),
            "juice": NSNumber(integerLiteral: data.juice),
            "total": NSNumber(integerLiteral: data.total())
        ])
        userDBRef.child("water/water\(id)").setValue(dict) { error, _ in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
