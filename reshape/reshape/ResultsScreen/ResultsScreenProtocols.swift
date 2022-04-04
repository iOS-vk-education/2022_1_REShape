//
//  ResultsScreenProtocols.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

protocol ResultsScreenModuleInput {
	var moduleOutput: ResultsScreenModuleOutput? { get }
}

protocol ResultsScreenModuleOutput: AnyObject {
}

protocol ResultsScreenViewInput: AnyObject {
}

protocol ResultsScreenViewOutput: AnyObject {
    func caloriesTapped()
}

protocol ResultsScreenInteractorInput: AnyObject {
}

protocol ResultsScreenInteractorOutput: AnyObject {
}

protocol ResultsScreenRouterInput: AnyObject {
    func didCaloriesTapped()
}
