//
//  WaterScreenProtocols.swift
//  reshape
//
//  Created by Полина Константинова on 12.04.2022.
//  
//

import Foundation

protocol WaterScreenModuleInput {
	var moduleOutput: WaterScreenModuleOutput? { get }
}

protocol WaterScreenModuleOutput: class {
}

protocol WaterScreenViewInput: class {
}

protocol WaterScreenViewOutput: class {
}

protocol WaterScreenInteractorInput: class {
}

protocol WaterScreenInteractorOutput: class {
}

protocol WaterScreenRouterInput: class {
}
