//
//  DietScreenProtocols.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

protocol DietScreenModuleInput {
	var moduleOutput: DietScreenModuleOutput? { get }
}

protocol DietScreenModuleOutput: class {
}

protocol DietScreenViewInput: class {
}

protocol DietScreenViewOutput: class {
}

protocol DietScreenInteractorInput: class {
}

protocol DietScreenInteractorOutput: class {
}

protocol DietScreenRouterInput: class {
}
