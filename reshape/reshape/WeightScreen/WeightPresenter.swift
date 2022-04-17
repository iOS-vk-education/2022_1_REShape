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
    func backButtonPressed() {
        router.backButtonTapped()
    }
    
}

extension WeightPresenter: WeightInteractorOutput {
}
