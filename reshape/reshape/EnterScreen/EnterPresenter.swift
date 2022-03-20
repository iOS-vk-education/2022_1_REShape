//
//  EnterPresenter.swift
//  reshape
//
//  Created by Иван Фомин on 18.03.2022.
//  
//

import Foundation

final class EnterPresenter {
	weak var view: EnterViewInput?
    weak var moduleOutput: EnterModuleOutput?
    
	private let router: EnterRouterInput
	private let interactor: EnterInteractorInput
    
    init(router: EnterRouterInput, interactor: EnterInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension EnterPresenter: EnterModuleInput {

}

extension EnterPresenter: EnterViewOutput {
    func showLoginScreen() {
        router.enterButtonPressed()
    }
}

extension EnterPresenter: EnterInteractorOutput {
}
//extension PhotosPresenter: PhotosViewOutput {
//    func getColorInfo(hexColor: String, rgbColor: String, photoViewModels: PhotoViewModel) {
//        router.addColorInfoToColorInfoScreen(hexColor: hexColor,
//                                             rgbColor: rgbColor,
//                                             photoViewModels: photoViewModels)
//    }
//
//    func loadNextPage(from start: Int, limit: Int) {
//        interactor.loadNextPage(from: start, limit: limit)
//    }
//
//    func viewDidLoad() {
//        interactor.loadFirstPage()
//    }
//
//}
