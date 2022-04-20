//
//  WeightPresenter.swift
//  reshape
//
//  Created by Иван Фомин on 15.04.2022.
//  
//

import Foundation

final class WeightPresenter {
	weak var view: WeightViewInput?
    weak var moduleOutput: WeightModuleOutput?
    
	private let router: WeightRouterInput
	private let interactor: WeightInteractorInput
    
    init(router: WeightRouterInput, interactor: WeightInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension WeightPresenter: WeightModuleInput {
}

extension WeightPresenter: WeightViewOutput {
    func getShortDate(atBackPosition position: Int) -> String {
        return interactor.getWeightData(atBackPosition: position).getShortDateString()
    }
    
    func getWeight(atBackPosition position: Int) -> Int {
        return interactor.getWeightData(atBackPosition: position).getWeight()
    }
    
    func uploadNewWeight(newDate date: String, newTime time: String, newWeight weight: Int) {
        let weightData = WeightDataModel(date: date, time: time, weight: weight)
        interactor.uploadNewWeight(weightData: weightData)
    }
    
    func getLastTime() -> String {
        return interactor.getLastWeightData().getTimeString()
    }
    
    func getLastDate() -> String {
        return interactor.getLastWeightData().getDateString()
    }
    
    func getLastWeight() -> Int {
        return interactor.getLastWeightData().getWeight()
    }
    
    func backButtonPressed() {
        router.backButtonTapped()
    }
    
}

extension WeightPresenter: WeightInteractorOutput {
    func newWeightGetting() {
        view?.reloadData()
    }
    
    func undoUploadNewWeight() {
        view?.cancelEditing()
    }
    
}
