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
    }
    
    private func getDataFromLocalBase() {
        viewModels = defaults.array(forKey: "WeightData") as? [WeightDataModel] ?? [
            WeightDataModel(date: "15 апреля 2022г", time: "12:45", weight: 45),
            WeightDataModel(date: "16 апреля 2022г", time: "16:45", weight: 47),
            WeightDataModel(date: "17 апреля 2022г", time: "13:28", weight: 47),
        ]
    }
    
    private func getDataFromRemoteBase() {
        
    }
}

extension WeightInteractor: WeightInteractorInput {
    func getLastWeightData() -> WeightDataModel {
        getDataFromRemoteBase()
        return viewModels.last ?? WeightDataModel()
    }
}
