//
//  ResultsScreenProtocols.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

protocol ResultsScreenModuleInput {
	var moduleOutput: ResultsScreenModuleOutput? { get }
}

protocol ResultsScreenModuleOutput: AnyObject {
}

protocol ResultsScreenViewInput: AnyObject {
    func reloadCollectionView()
    func updateViewWithUserData(viewModel: ResultViewModel)
    func updateViewWithError(error: Error)
    func updateViewWithTotalPercent(_ totalPercent: Float)
    func updateViewWithTasks(_ totalTasks: Int)
}

protocol ResultsScreenViewOutput: AnyObject {
    func caloriesTapped()
    func weightTapped()
    func didLoadInfo()
    func didGetPart(target: Double, current: Double) -> Float
    func didGetPercent(target: Double, current: Double) -> Float
    func didGetTargetWater(currentWater: Double) -> Double
    func didGetDifference(currentWeight: Double, firstWeight: Double) -> Double
    func didGetResultPercent(waterPercent: Float, caloriesPercent: Float, weightPercent: Float) -> Float
    func countTotalPercent(waterPercent: Float, caloriesPercent: Float, weightPercent: Float)
    func countTotalTasks(waterPercent: Float, caloriesPercent: Float, weightPercent: Float)

}

protocol ResultsScreenInteractorInput: AnyObject {
    func loadInfo()
    func getPart(target: Double, current: Double) -> Float
    func getPercent(target: Double, current: Double) -> Float
    func getTargetWater(currentWater: Double) -> Double
    func getDifference(currentWeight: Double, firstWeight: Double) -> Double
    func getResultPercent(waterPercent: Float, caloriesPercent: Float, weightPercent: Float) -> Float
    func getTotalTask(waterPercent: Float, caloriesPercent: Float, weightPercent: Float) -> Int
    func willCountTotalPercent(waterPercent: Float, caloriesPercent: Float, weightPercent: Float)
    func willCountTotalTasks(waterPercent: Float, caloriesPercent: Float, weightPercent: Float)


}

protocol ResultsScreenInteractorOutput: AnyObject {
    func updateNumOfDays()
    func didLoadUserData(user: User, day: Int, targetCal: Double)
    func didCatchError(error: Error)
    func didCountTotalPercent(totalPercent: Float)
    func didCountTotalTasks(totalTasks: Int)

}

protocol ResultsScreenRouterInput: AnyObject {
    func didCaloriesTapped()
    func didWeightTapped()
}
