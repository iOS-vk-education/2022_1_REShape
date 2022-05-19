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
    func getNumOfDays() -> Int {
        return interactor.getSize()
    }
    
    func getCurrentDate() -> String {
        return Date().dateString()
    }
    
    func getCurrentTime() -> String {
        return Date().timeString()
    }
    
    func getShortDate(atPosition position: Int) -> String {
        return interactor.getWeightData(fromPosition: position)?.getShortDateString() ?? ""
    }
    
    func getWeight(atPosition position: Int) -> String {
        return interactor.getWeightData(fromPosition: position)?.getWeight() ?? ""
    }
    
    func uploadNewWeight(newDate date: String, newTime time: String, newWeight weight: String) {
        let uploadData = WeightStruct(weight: weight, date: date, time: time)
        interactor.uploadNewWeight(uploadData)
    }
    
    func getLastTime() -> String {
        let numOfDay = interactor.getSize()
        let weightData = interactor.getWeightData(fromPosition: numOfDay-1)
        return weightData?.getTimeString() ?? ""
    }
    
    func getLastDate() -> String {
        let numOfDay = interactor.getSize()
        let weightData = interactor.getWeightData(fromPosition: numOfDay-1)
        return weightData?.getDateString() ?? ""
    }
    
    func getLastWeight() -> String {
        let numOfDay = interactor.getSize()
        let weightData = interactor.getWeightData(fromPosition: numOfDay-1)
        return weightData?.getWeight() ?? ""
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
