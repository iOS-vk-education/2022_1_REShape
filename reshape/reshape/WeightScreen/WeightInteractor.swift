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
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func getDataFromRemoteBase() {
        print("[DEBUG] Запрос на загрузку удаленной БД весов")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            // Обновление данных по ID
            self.localViewModels.forEach() { model in
                switch model.getID() {
                case 0:
                    model.setData(id: 0, dateString: "15 апреля 2022г", timeString: "12:45", weightString: "45")
                case 1:
                    model.setData(id: 1, dateString: "16 апреля 2022г", timeString: "16:45", weightString: "47")
                case 2:
                    model.setData(id: 2, dateString: "17 апреля 2022г", timeString: "13:28", weightString: "47")
                default:
                    break
                }
            }
            self.weightModelController.saveContext()
            
            // Получение обновлений для локальной БД
            self.updateLocalBase()
            self.output?.newWeightGetting()
        })
    }
}

extension WeightInteractor: WeightInteractorInput {
    func getWeightData(atBackPosition position: Int) -> WeightModel? {
        let pos = localViewModels.count - position - 1
        return localViewModels.first() {weightModel in
            weightModel.getID() == pos ? true : false
        }
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
        return getWeightData(atBackPosition: 0)
    }
}
