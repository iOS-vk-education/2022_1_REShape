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

protocol ProfileScreenModuleOutput: AnyObject {
}

protocol ProfileScreenViewInput: AnyObject {
}

protocol ProfileScreenViewOutput: AnyObject {
}

protocol ProfileScreenInteractorInput: AnyObject {
}

protocol ProfileScreenInteractorOutput: AnyObject {
}

protocol ProfileScreenRouterInput: AnyObject {
}
