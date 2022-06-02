//
//  WaterScreenInteractor.swift
//  reshape
//
//  Created by Полина Константинова on 16.04.2022.
//  
//

import Foundation

final class WaterScreenInteractor {
	weak var output: WaterScreenInteractorOutput?
    weak var firebaseController: WaterFirebaseProtocol?
}

extension WaterScreenInteractor: WaterScreenInteractorInput {
    func requestData() {
        firebaseController?.loadIndividualInfo(completion: { [weak self] error in
            // Блок проверок
            guard error == nil else { return }
            guard self != nil else { return }
            
            // Сигнал об изменении данных
            self!.output?.updateData()
        })
    }
    
    func getData() -> WaterStruct {
        return firebaseController?.getCurrentWaterData() ?? WaterStruct()
    }
    
    func getTotal() -> Int {
        return Int(firebaseController?.getCurrentWater() ?? 0)
    }
    
    func send(water data: WaterStruct) {
        firebaseController?.sendWater(withData: data, completion: { [weak self] error in
            // Блок проверок ошибок
            guard self != nil else { return }
            guard error == nil else {
                self!.output?.updateData()
                return
            }
            
            // Получение обновленных данных
            self!.requestData()
        })
    }
}
