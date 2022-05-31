//
//  ResultsScreenInteractor.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

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
//                var currentDay = 0
                
//                if self?.firebaseController?.getDaysCount() != 0 {
//                   currentDay  = currDay % ((self?.firebaseController?.getDaysCount() ?? 10)) + 1
//                } else {
//                    currentDay = 1
//                }
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
    
    func getDifference(currentWeight: Double, firstWeight: Double) -> Double {
        let difference = (round(currentWeight * 10) / 10) - firstWeight
        return round(difference * 10) / 10
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
