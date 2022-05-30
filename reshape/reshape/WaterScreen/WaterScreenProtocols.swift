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
    func updateCollectionView()
}

protocol WaterScreenViewOutput: AnyObject {
    func backButtonPressed()
    func getWater() -> String
    func getCoffee() -> String
    func getTea() -> String
    func getFizzy() -> String
    func getMilk() -> String
    func getAlco() -> String
    func getJuice() -> String
    func getTotal() -> Int
    
    func send(water: String,
              coffee: String,
              tea: String,
              fizzy: String,
              milk: String,
              alco: String,
              juice: String
    )
    
    func requestData()
}

protocol WaterScreenInteractorInput: AnyObject {
    func getData() -> WaterStruct
    func getTotal() -> Int
    
    func send(water data: WaterStruct)
    
    func requestData()
}

protocol WaterScreenInteractorOutput: AnyObject {
    func updateData()
}

protocol WaterScreenRouterInput: AnyObject {
    func backButtonTapped()
}
