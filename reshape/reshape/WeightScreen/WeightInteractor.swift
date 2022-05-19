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
    private let firebaseController: WeightFirebaseController
    
    init() {
        weightModelController = WeightModelController()
        firebaseController = WeightFirebaseController()
        loadFromLocalBase()
        getDataFromRemoteBase()
    }
    
    private func loadFromLocalBase() {
        do {
            localViewModels = try weightModelController.getWeightData()
            self.output?.newWeightGetting()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func getDataFromRemoteBase() {
        print("[DEBUG] Запрос на загрузку удаленной БД весов")
        firebaseController.loadIndividualInfo { [weak self] error in
            // Блок проверок
            guard (error == nil) else { return }
            guard (self != nil) else { return }
            guard let weightDataSize = self?.firebaseController.getWeightCount() else { return }
            
            // Удаление данных в случае отстутсвия данных
            if weightDataSize < 1 {
                self!.weightModelController.flushData()
                self!.localViewModels.removeAll()
                self!.output?.newWeightGetting()
                return
            }
            
            // Проверка на лишние данные
            let currentSize = self!.getSize()
            if currentSize > weightDataSize {
                for id in weightDataSize...currentSize-1 {
                    guard let model = self!.getWeightData(fromPosition: id) else { continue }
                    self!.weightModelController.deleteWeightData(model)
                    self!.localViewModels.removeAll(where: { $0 == model })
                }
            }
            
            // Обновление существующих
            for id in 0...weightDataSize-1 {
                let newData = self!.firebaseController.downloadData(forId: id)
                
                guard let model = self!.getWeightData(fromPosition: id) else {
                    let newWeight = self!.weightModelController.setWeightData(forID: id ,weightString: newData.weight, dateString: newData.date, timeString: newData.time)
                    self!.localViewModels.append(newWeight)
                    continue
                }
                model.setData(id: id, dateString: newData.date, timeString: newData.time, weightString: newData.weight)
            }
            // Обновление отображения
            self!.weightModelController.saveContext()
            self!.output?.newWeightGetting()
        }
    }
    
    private func ifLoadSuccess(error: Error?, data: WeightStruct) {
        // Проверка на ошибки
        guard error == nil else {
            output?.undoUploadNewWeight()
            return
        }
        
        // Добавление новых данных в случае удачи
        let nextID = getSize()
        let newData = weightModelController.setWeightData(forID: nextID ,weightString: data.weight, dateString: data.date, timeString: data.time)
        localViewModels.append(newData)
            
        // Сохранение обновленных данных
        weightModelController.saveContext()
            
        // Обновление данных
        output?.newWeightGetting()
    }
}

extension WeightInteractor: WeightInteractorInput {
    func getWeightData(fromPosition position: Int) -> WeightModel? {
        guard position < getSize() else { return nil }
        let weightModel = localViewModels.first {
            $0.modelID == position
        }
        return weightModel
    }
    
    func getSize() -> Int {
        guard let weightModelMaxID = localViewModels.max(by: { a, b in
            a.modelID < b.modelID
        })?.getID() else { return 0 }
        return weightModelMaxID + 1
    }
    
    func uploadNewWeight(_ data: WeightStruct) {
        print("[DEBUG] Загрузка локальной БД (обновления БД) весов на сервер")
        firebaseController.uploadWeight(forID: localViewModels.count, withWeight: data, completion: ifLoadSuccess(error:data:))
    }
}
