//
//  WeightProtocols.swift
//  reshape
//
//  Created by Иван Фомин on 15.04.2022.
//  
//

import Foundation

protocol WeightModuleInput {
	var moduleOutput: WeightModuleOutput? { get }
}

protocol WeightModuleOutput: AnyObject {
}

protocol WeightViewInput: AnyObject {
}

protocol WeightViewOutput: AnyObject {
    func backButtonPressed()
    func getLastWeightData() -> WeightDataModel
}

protocol WeightInteractorInput: AnyObject {
    func getLastWeightData() -> WeightDataModel
}

protocol WeightInteractorOutput: AnyObject {
}

protocol WeightRouterInput: AnyObject {
    func backButtonTapped()
}
