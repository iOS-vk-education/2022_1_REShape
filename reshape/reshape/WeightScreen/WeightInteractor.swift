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
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            // Обновление данных по ID
            for i in 0...2 {
                let model = self.getWeightData(fromID: i)
                if model != nil {
                    self.coreDataContext.delete(model!)
                    self.weightModelController.saveContext()
                }
                switch i {
                case 0:
                    self.coreDataContext.insert(WeightModel(id: i, dateString: "15 апреля 2022г", timeString: "12:45", weightString: "45", context: self.coreDataContext))
                case 1:
                    self.coreDataContext.insert(WeightModel(id: i, dateString: "16 апреля 2022г", timeString: "16:45", weightString: "47", context: self.coreDataContext))
                case 2:
                    self.coreDataContext.insert(WeightModel(id: i, dateString: "17 апреля 2022г", timeString: "13:28", weightString: "47", context: self.coreDataContext))
                default:
                    break
                }
            }
            self.weightModelController.saveContext()
            
            // Получение обновлений для локальной БД
            self.updateLocalBase()
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
    func getWeightData(fromBackPosition position: Int) -> WeightModel? {
        guard let maxID = getMaxID() else { return nil }
        let neededId = maxID - position
        if neededId < 0 { return nil }
        let weightModel = localViewModels.first(where: { model in
            model.modelID == maxID
        })
        return weightModel
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
        coreDataContext.insert(WeightModel(id: localViewModels.count, dateString: date, timeString: time, weightString: weight, context: coreDataContext))
        // Сохранение обновленных данных
        weightModelController.saveContext()
        updateLocalBase()
        
        // Если неудачно
//        output?.undoUploadNewWeight()
    }
    
    func getLastWeightData() -> WeightModel? {
        return getWeightData(fromBackPosition: 0)
    }
}
