//
//  ResultsScreenPresenter.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import Foundation

final class ResultsScreenPresenter {
	weak var view: ResultsScreenViewInput?
    weak var moduleOutput: ResultsScreenModuleOutput?
    
	private let router: ResultsScreenRouterInput
	private let interactor: ResultsScreenInteractorInput
    
    init(router: ResultsScreenRouterInput, interactor: ResultsScreenInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
   
}

extension ResultsScreenPresenter: ResultsScreenModuleInput {
}

extension ResultsScreenPresenter: ResultsScreenViewOutput {


    func didLoadInfo() {
        interactor.loadInfo()
    }
  
    func weightTapped() {
        router.didWeightTapped()
    }
    
    func caloriesTapped() {
        router.didCaloriesTapped()
    }
    func didGetPart(target: Double, current: Double) -> Float {
        return interactor.getPart(target: target, current: current)
    }
    func didGetPercent(target: Double, current: Double) -> Float {
        return interactor.getPercent(target: target, current: current)
    }

    func didGetTargetWater(currentWater: Double) -> Double {
        return interactor.getTargetWater(currentWater: currentWater)
    }

    func didGetDifference(currentWeight: Double, firstWeight: Double) -> Double{
        return interactor.getDifference(currentWeight: currentWeight,
                                        firstWeight: firstWeight)
    }
    func didGetResultPercent(waterPercent: Float, caloriesPercent: Float, weightPercent: Float) -> Float {
        return interactor.getResultPercent(waterPercent: waterPercent,
                                           caloriesPercent: caloriesPercent,
                                           weightPercent: weightPercent)
    }

    func countTotalPercent(waterPercent: Float, caloriesPercent: Float, weightPercent: Float) {
        interactor.willCountTotalPercent(waterPercent: waterPercent, caloriesPercent: caloriesPercent, weightPercent: weightPercent)
    }
    func countTotalTasks(waterPercent: Float, caloriesPercent: Float, weightPercent: Float) {
        interactor.willCountTotalTasks(waterPercent: waterPercent, caloriesPercent: caloriesPercent, weightPercent: weightPercent)
    }
    func waterTapped() {
        router.didWaterTapped()
    }
    
}

extension ResultsScreenPresenter: ResultsScreenInteractorOutput {
    func didCountTotalTasks(totalTasks: Int) {
        view?.updateViewWithTasks(totalTasks)
    }
    
    func didCountTotalPercent(totalPercent: Float) {
        view?.updateViewWithTotalPercent(totalPercent)
    }
    
    func didLoadUserData(user: User, day: Int, targetCal: Double) {
        let weightKey = user.weights.keys.max()
        let currWeight = user.weights[weightKey ?? ""]
        let currWater = user.water?["water\(day - 1)"]
        guard let phototUrl = URL(string: user.photo)
        else {
            return
        }
        let currCal = user.calories?["day\(day)"] ?? 0
        let doubleCurrWater = Double(currWater?.total ?? 0) / 1000
        let viewModel = ResultViewModel(name: user.name,
                                        surname: user.surname,
                                        currentCalories: Double(currCal),
                                        targetCalories: targetCal,
                                        currentDay: day,
                                        currentWeight: currWeight?.weight ?? "",
                                        firstWeight: user.weight ?? "",
                                        targetWeight: user.target,
                                        currentWater: doubleCurrWater,
                                        photoURL: phototUrl)
        view?.updateViewWithUserData(viewModel: viewModel)
        print(user)
        view?.reloadCollectionView()
    }
    
    func didCatchError(error: Error){
        view?.updateViewWithError(error: error)
    }
    func updateNumOfDays() {
        
    }
}
