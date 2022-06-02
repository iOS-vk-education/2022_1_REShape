//
//  WaterScreenPresenter.swift
//  reshape
//
//  Created by Полина Константинова on 16.04.2022.
//  
//

import Foundation

final class WaterScreenPresenter {
	weak var view: WaterScreenViewInput?
    weak var moduleOutput: WaterScreenModuleOutput?
    
	private let router: WaterScreenRouterInput
	private let interactor: WaterScreenInteractorInput
    
    init(router: WaterScreenRouterInput, interactor: WaterScreenInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension WaterScreenPresenter: WaterScreenModuleInput {
}

extension WaterScreenPresenter: WaterScreenViewOutput {
    func getWeight() -> Double {
        return interactor.getData().weight
    }
    
    func requestData() {
        interactor.requestData()
    }
    
    func send(water: String, coffee: String, tea: String, fizzy: String, milk: String, alco: String, juice: String) {
        let data: WaterStruct = WaterStruct(water: Int(water) ?? 0,
                                            coffee: Int(coffee) ?? 0,
                                            tea: Int(tea) ?? 0,
                                            fizzy: Int(fizzy) ?? 0,
                                            milk: Int(milk) ?? 0,
                                            alcohol: Int(alco) ?? 0,
                                            juice: Int(juice) ?? 0)
        interactor.send(water: data)
    }
    
    func getWater() -> String {
        let water = Int(interactor.getData().water)
        return "\(water)"
    }
    
    func getCoffee() -> String {
        let coffee = Int(interactor.getData().coffee)
        return "\(coffee)"
    }
    
    func getTea() -> String {
        let tea = Int(interactor.getData().tea)
        return "\(tea)"
    }
    
    func getFizzy() -> String {
        let fizzy = Int(interactor.getData().fizzy)
        return "\(fizzy)"
    }
    
    func getMilk() -> String {
        let milk = Int(interactor.getData().milk)
        return "\(milk)"
    }
    
    func getAlco() -> String {
        let alco = Int(interactor.getData().alcohol)
        return "\(alco)"
    }
    
    func getJuice() -> String {
        let juice = Int(interactor.getData().juice)
        return "\(juice)"
    }
    
    func getTotal() -> Int {
        return interactor.getTotal()
    }
    
    
    
    func backButtonPressed() {
        router.backButtonTapped()
    }
}

extension WaterScreenPresenter: WaterScreenInteractorOutput {
    func updateData() {
        view?.updateCollectionView()
    }
}
