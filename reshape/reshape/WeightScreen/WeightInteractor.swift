//
//  WeightInteractor.swift
//  reshape
//
//  Created by Иван Фомин on 15.04.2022.
//

import Foundation
import CoreData

final class WeightInteractor {
    weak var output: WeightInteractorOutput?
    private var localViewModels: [WeightModel] = []
    private let weightModelController: WeightModelController
    private let coreDataContext: NSManagedObjectContext
    
    init(coreDataController: WeightModelController) {
        weightModelController = coreDataController
        coreDataContext = weightModelController.managedObjectContext
        updateLocalBase()
        getDataFromRemoteBase()
    }
    
    deinit {
        weightModelController.saveContext()
    }
    
    private func updateLocalBase() {
        do {
            let fetchRequest = WeightModel.fetchRequest()
            let result = try coreDataContext.fetch(fetchRequest)
            localViewModels = result
            self.output?.newWeightGetting()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func getDataFromRemoteBase() {
        print("[DEBUG] Запрос на загрузку удаленной БД весов")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            // Данные с FireBase
            let firebaseData = [
                FireBaseWeightModel(modelID: 0, modelDate: "15 апреля 2022г", modelTime: "12:45", modelWeight: "45"),
                FireBaseWeightModel(modelID: 1, modelDate: "16 апреля 2022г", modelTime: "16:45", modelWeight: "47"),
                FireBaseWeightModel(modelID: 2, modelDate: "17 апреля 2022г", modelTime: "13:28", modelWeight: "47")
            ]
            
            // Обновление данных по ID
            for data in firebaseData {
                guard let model = self.getWeightData(fromID: data.modelID) else {
                    self.localViewModels.append(WeightModel(id: data.modelID, dateString: data.modelDate, timeString: data.modelTime, weightString: data.modelWeight, context: self.coreDataContext))
                    continue
                }
                model.setData(id: data.modelID, dateString: data.modelDate, timeString: data.modelTime, weightString: data.modelWeight)
            }
            self.weightModelController.saveContext()
            
            // Обновление отображения
            self.output?.newWeightGetting()
        })
    }
    
    private func getWeightData(fromID id: Int) -> WeightModel? {
        let weightModel = localViewModels.first(where: { model in
            model.modelID == id
        })
        return weightModel
    }
}

extension WeightInteractor: WeightInteractorInput {
    func flushWeightModel() {
        weightModelController.flushData()
        updateLocalBase()
        getDataFromRemoteBase()
    }
    
    func getWeightData(fromBackPosition position: Int) -> WeightModel? {
        guard let maxID = getMaxID() else { return nil }
        let neededId = maxID - position
        if neededId < 0 { return nil }
        return getWeightData(fromID: neededId)
    }
    
    func getMaxID() -> Int? {
        guard let weightModelMaxID = localViewModels.max(by: { a, b in
            a.modelID < b.modelID
        })?.getID() else { return nil }
        return weightModelMaxID
    }
    
    func uploadNewWeight(newDate date: String, newTime time: String, newWeight weight: String) {
        print("[DEBUG] Загрузка локальной БД (обновления БД) весов на сервер")
        // Если удачно загрузилось
        localViewModels.append(WeightModel(id: localViewModels.count, dateString: date, timeString: time, weightString: weight, context: coreDataContext))
        
        // Сохранение обновленных данных
        weightModelController.saveContext()
        
        // Обновление данных
        self.output?.newWeightGetting()
        
        // Если неудачно
//        output?.undoUploadNewWeight()
    }
    
    func getLastWeightData() -> WeightModel? {
        return getWeightData(fromBackPosition: 0)
    }
}
