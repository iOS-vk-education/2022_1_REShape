//
//  ResultsScreenPresenter.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

final class ResultsScreenPresenter {
	weak var view: ResultsScreenViewInput?
    weak var moduleOutput: ResultsScreenModuleOutput?
    
	private let router: ResultsScreenRouterInput
	private let interactor: ResultsScreenInteractorInput
    
    init(router: ResultsScreenRouterInput, interactor: ResultsScreenInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension ResultsScreenPresenter: ResultsScreenModuleInput {
}

extension ResultsScreenPresenter: ResultsScreenViewOutput {
}

extension ResultsScreenPresenter: ResultsScreenInteractorOutput {
}
