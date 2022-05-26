//
//  ResultsScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

final class ResultsScreenInteractor {
	weak var output: ResultsScreenInteractorOutput?
    weak var firebaseController: ResultFirebaseProtocol?
}

extension ResultsScreenInteractor: ResultsScreenInteractorInput {
}
