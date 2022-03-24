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

protocol ResultsScreenModuleOutput: class {
}

protocol ResultsScreenViewInput: class {
}

protocol ResultsScreenViewOutput: class {
}

protocol ResultsScreenInteractorInput: class {
}

protocol ResultsScreenInteractorOutput: class {
}

protocol ResultsScreenRouterInput: class {
}
