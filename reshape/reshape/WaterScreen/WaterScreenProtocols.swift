//
//  WaterScreenProtocols.swift
//  reshape
//
//  Created by Полина Константинова on 16.04.2022.
//  
//

import Foundation

protocol WaterScreenModuleInput {
	var moduleOutput: WaterScreenModuleOutput? { get }
}

protocol WaterScreenModuleOutput: AnyObject {
}

protocol WaterScreenViewInput: AnyObject {
}

protocol WaterScreenViewOutput: AnyObject {
    func backButtonPressed()
}

protocol WaterScreenInteractorInput: AnyObject {
}

protocol WaterScreenInteractorOutput: AnyObject {
}

protocol WaterScreenRouterInput: AnyObject {
    func backButtonTapped()
}
