//
//  WeightInteractor.swift
//  reshape
//
//  Created by Иван Фомин on 15.04.2022.
//

import Foundation

final class WeightInteractor {
    weak var output: WeightInteractorOutput?
    private var viewModels = [WeightDataModel]()
    
    init() {
        getDataFromLocalBase()
        getDataFromRemoteBase()
    }
    
    private func getDataFromLocalBase() {
        viewModels = defaults.array(forKey: "WeightData") as? [WeightDataModel] ?? [
            WeightDataModel(date: "15 апреля 2022г", time: "12:45", weight: 45),
            WeightDataModel(date: "16 апреля 2022г", time: "16:45", weight: 47),
            WeightDataModel(date: "17 апреля 2022г", time: "13:28", weight: 47),
        ]
    }
    
    deinit {
        defaults.set(viewModels, forKey: "WeightData")
    }
    
    private func getDataFromRemoteBase() {
        print("[DEBUG] Запрос на загрузку удаленной БД весов")
//        /* Необходимо разблокировать после реализации загрузки из удаленной БД */
//        let newWeight = [WeightDataModel]()
//        newWeight.enumerated().forEach({
//            if $1 != self.viewModels[$0] {
//                self.viewModels.insert($1, at: $0)
//            }
//        })
//        self.newWeightGetting()
    }
}

extension WeightInteractor: WeightInteractorInput {
    func getWeightData(atBackPosition position: Int) -> WeightDataModel {
        let pos = viewModels.count - position - 1
        return (pos >= 0) ? viewModels[pos] : WeightDataModel()
    }
    
    func uploadNewWeight(weightData: WeightDataModel) {
        viewModels.append(weightData)
        print("[DEBUG] Загрузка локальной БД (обновления БД) весов на сервер")
    }
    
    func getLastWeightData() -> WeightDataModel {
        return getWeightData(atBackPosition: 0)
    }
}
