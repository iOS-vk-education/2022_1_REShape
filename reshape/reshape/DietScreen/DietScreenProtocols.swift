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

protocol DietScreenModuleOutput: AnyObject {
}

protocol DietScreenViewInput: AnyObject {
}

protocol DietScreenViewOutput: AnyObject {
}

protocol DietScreenInteractorInput: AnyObject {
}

protocol DietScreenInteractorOutput: AnyObject {
}

protocol DietScreenRouterInput: AnyObject {
}
