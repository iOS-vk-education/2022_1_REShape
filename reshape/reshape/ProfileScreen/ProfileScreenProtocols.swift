//
//  ProfileScreenProtocols.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

protocol ProfileScreenModuleInput {
	var moduleOutput: ProfileScreenModuleOutput? { get }
}

protocol ProfileScreenModuleOutput: class {
}

protocol ProfileScreenViewInput: class {
}

protocol ProfileScreenViewOutput: class {
}

protocol ProfileScreenInteractorInput: class {
}

protocol ProfileScreenInteractorOutput: class {
}

protocol ProfileScreenRouterInput: class {
}
