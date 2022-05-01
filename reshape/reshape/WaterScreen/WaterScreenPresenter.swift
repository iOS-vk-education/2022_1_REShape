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
    func backButtonPressed() {
        router.backButtonTapped()
    }
}

extension WaterScreenPresenter: WaterScreenInteractorOutput {
    
}
