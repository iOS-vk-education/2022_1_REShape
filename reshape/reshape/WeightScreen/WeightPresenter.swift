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
    func getCurrentDate() -> String {
        return Date().dateString()
    }
    
    func getCurrentTime() -> String {
        return Date().timeString()
    }
    
    func getShortDate(atBackPosition position: Int) -> String {
        return interactor.getWeightData(fromBackPosition: position)?.getShortDateString() ?? ""
    }
    
    func getWeight(atBackPosition position: Int) -> String {
        return interactor.getWeightData(fromBackPosition: position)?.getWeight() ?? ""
    }
    
    func uploadNewWeight(newDate date: String, newTime time: String, newWeight weight: String) {
        interactor.uploadNewWeight(newDate: date, newTime: time, newWeight: weight)
    }
    
    func getLastTime() -> String {
        return interactor.getLastWeightData()?.getTimeString() ?? ""
    }
    
    func getLastDate() -> String {
        return interactor.getLastWeightData()?.getDateString() ?? ""
    }
    
    func getLastWeight() -> String {
        return interactor.getLastWeightData()?.getWeight() ?? ""
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
