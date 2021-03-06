//
//  ResultsScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation
import Firebase

final class ResultsScreenInteractor {
    weak var output: ResultsScreenInteractorOutput?
    weak var firebaseController: ResultFirebaseProtocol?
    private let resultsNetworkManager: ResultsNetworkManagerProtocol?
    init() {
        resultsNetworkManager = ResultsNetworkManager()
        firebaseController = nil
    }
    
}

extension ResultsScreenInteractor: ResultsScreenInteractorInput {

    func loadInfo() {
        resultsNetworkManager?.getUserData {[weak self] result in
            switch result {
            case .success(let (userData, currDay)):
                let decoder = JSONDecoder()
                let targetCal = self?.firebaseController?.getTargetCalories()
                guard
                let decoded = try? decoder.decode(User.self, from: userData)
                else {
                    return
                }
                self?.output?.didLoadUserData(user: decoded, day: currDay, targetCal: targetCal ?? 0)
            case .failure(let error):
                self?.output?.didCatchError(error: error)
            }
        }
    }
    
    func getPart(target: Double, current: Double) -> Float {
        let part: Double = current / target
        return Float(part)
    }
    
    func getPercent(target: Double, current: Double) -> Float {
        let percent: Double = (current / target) * 100
        let floatPercent = Float(percent)
        return round(floatPercent)
    }
    
    func getTargetWater(currentWater: Double) -> Double {
        let targetWater = currentWater * 30 / 1000
        return targetWater
    }
    
    func getPercentWeight(currentWeight: Double, firstWeight: Double, targetWeight: Double) -> Double {
        let difference = (round(firstWeight * 10) / 10) - targetWeight
        var percent: Double = 0
        if currentWeight >= firstWeight {
            percent = 0
//        } else if currentWeight == targetWeight {
//            percent = 100
        } else {
            percent = (firstWeight - currentWeight) / difference * 100
        }
        
        return round(percent)
    }
    
    func getResultPercent(waterPercent: Float, caloriesPercent: Float, weightPercent: Float) -> Float {
        let resultPercent = (waterPercent + caloriesPercent + weightPercent) / 3
        return resultPercent
    }
    func getTotalTask(waterPercent: Float, caloriesPercent: Float, weightPercent: Float) -> Int {
        var totalTask = 0
        var waterTask = 0, caloriesTask = 0, weightTask = 0
        if waterPercent >= 100 {
            waterTask = 1
        }
        if caloriesPercent >= 100 {
            caloriesTask = 1
        }
        if weightPercent >= 100 {
            weightTask = 1
        }
        totalTask = waterTask + caloriesTask + weightTask
        return totalTask
    }
    func willCountTotalPercent(waterPercent: Float, caloriesPercent: Float, weightPercent: Float) {
        output?.didCountTotalPercent(totalPercent: getResultPercent(waterPercent: waterPercent,
                                                                    caloriesPercent: caloriesPercent,
                                                                    weightPercent: weightPercent))
    }
    func willCountTotalTasks(waterPercent: Float, caloriesPercent: Float, weightPercent: Float) {
        output?.didCountTotalTasks(totalTasks: getTotalTask(waterPercent: waterPercent,
                                                            caloriesPercent: caloriesPercent,
                                                            weightPercent: weightPercent))
    }
    

    
}
