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
    private var localViewModels = [OldWeightDataModel]()
    private var remoteViewModels = [OldWeightDataModel]()
    
    init() {
        getDataFromLocalBase()
        getDataFromRemoteBase()
        
    }
    
    deinit {
        saveLocalBase()
    }
    
    private func getDataFromLocalBase() {
        localViewModels = [
            OldWeightDataModel(date: "15 апреля 2022г", time: "12:45", weight: "45"),
            OldWeightDataModel(date: "16 апреля 2022г", time: "16:45", weight: "47"),
            OldWeightDataModel(date: "17 апреля 2022г", time: "13:28", weight: "47"),
        ]
    }
    
    private func getDataFromRemoteBase() {
        print("[DEBUG] Запрос на загрузку удаленной БД весов")
        remoteViewModels = [OldWeightDataModel()]
//        /* Необходимо разблокировать после реализации загрузки из удаленной БД */
//        updateLocalBase()
//        self.newWeightGetting()
    }
    
    private func updateLocalBase() {
        remoteViewModels.enumerated().forEach({
            if $1 != self.localViewModels[$0] {
                self.localViewModels.replaceSubrange($0...$0, with: [$1])
            }
        })
    }
    
    private func saveLocalBase() {
        
    }
}

extension WeightInteractor: WeightInteractorInput {
    func getWeightData(atBackPosition position: Int) -> OldWeightDataModel {
        let pos = localViewModels.count - position - 1
        return (pos >= 0) ? localViewModels[pos] : OldWeightDataModel()
    }
    
    func uploadNewWeight(weightData: OldWeightDataModel) {
        print("[DEBUG] Загрузка локальной БД (обновления БД) весов на сервер")
        // Если удачно загрузилось
        localViewModels.append(weightData)
        // Если неудачно
//        output?.undoUploadNewWeight()
    }
    
    func getLastWeightData() -> OldWeightDataModel {
        return getWeightData(atBackPosition: 0)
    }
}
