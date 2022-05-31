//
//  ResultsScreenViewController.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import UIKit

final class ResultsScreenViewController: UIViewController {
    private let output: ResultsScreenViewOutput
    private let mainView: CustomView = CustomView()
    private lazy var resultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    private let progress: CircularProgressBarView = CircularProgressBarView(
        frame: CGRect(
            x: 10.0,
            y: 30.0,
            width: 130.0,
            height: 130.0))
    private let targetLabel: UILabel = {
        let targetLabel = UILabel()
        targetLabel.translatesAutoresizingMaskIntoConstraints = false
        targetLabel.text = "Цели на сегодня:"
        targetLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        targetLabel.textColor = .black
        targetLabel.textAlignment = .left
        return targetLabel
    }()
    
    private var viewModel: ResultViewModel?
    
    init(output: ResultsScreenViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupUI()
        setupCollectionView()
        output.didLoadInfo()
        reloadCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.didLoadInfo()
        reloadCollectionView()

    }
}

extension ResultsScreenViewController: ResultsScreenViewInput {
    func updateViewWithTotalPercent(_ totalPercent: Float) {
        self.mainView.progressNumberLabel.text = "\(totalPercent.rounded())%"
        var totalPart: Float = totalPercent / 100
        if totalPart > 1 {
            totalPart = 1
        }
        self.mainView.photoProgressView.animateProgress(value: totalPart)
    }
    func updateViewWithTasks(_ totalTasks: Int){
        self.mainView.targetNumberLabel.text = "\(totalTasks)"
    }
    
    func updateViewWithUserData(viewModel: ResultViewModel) {
        DispatchQueue.main.async {
            self.viewModel = viewModel
            let name = viewModel.name
            let surname = viewModel.surname
            let photoURL = viewModel.photoURL
            self.mainView.nameLabel.text = name + " " + surname
            self.mainView.photoProgressView.personImage.loadImage(photoURL: photoURL)
            self.resultsCollectionView.reloadData()
        }
    }

    func updateViewWithError(error: Error){
        self.makeAlert("Ошибка", error.localizedDescription)
    }
    
    private func setupConstraints(){
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.top(isIncludeSafeArea: false)
        mainView.leading()
        mainView.trailing()
        mainView.height(view.bounds.height / 2.5)
        view.addSubview(targetLabel)
        NSLayoutConstraint.activate([
            targetLabel.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 21)
        ])
        targetLabel.leading(33)
        view.addSubview(resultsCollectionView)
        NSLayoutConstraint.activate([
            resultsCollectionView.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 11)
        ])
        resultsCollectionView.centerX()
        resultsCollectionView.leading()
        resultsCollectionView.trailing()
        resultsCollectionView.height(view.bounds.height / 2.5)
        
    }
    func reloadCollectionView() {
        guard let name = viewModel?.name else { return }
        guard let surname = viewModel?.surname else { return }
        guard let photoURL = viewModel?.photoURL else {return}
        mainView.nameLabel.text = name + " " + surname
        mainView.photoProgressView.personImage.loadImage(photoURL: photoURL)
        resultsCollectionView.reloadData()
    }
    private func setupUI(){
        view.backgroundColor = .white
        
        mainView.setupGradientColor(withColor: [UIColor.lightVioletColor.cgColor,
                                                UIColor.darkVioletColor.cgColor])
        mainView.setupGradientDirection(withDirection: .topToDown)
    }
    
    private func setupCollectionView(){
        resultsCollectionView.register(cellType: ResultCollectionCell.self)
    }
}
extension ResultsScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 72,
                      height: view.frame.height / 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(26.0)
    }
}
extension ResultsScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            self.output.caloriesTapped()
        case 1:
            self.output.weightTapped()
        case 2:
            self.output.waterTapped()
        default: break
        }
    }
}
extension ResultsScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(cellType: ResultCollectionCell.self, for: indexPath)
        
        let targetCal = viewModel?.targetCalories ?? 0
        let currentCal = viewModel?.currentCalories ?? 0
        let targetWeight = viewModel?.targetWeight ?? ""
        let currentWeight = viewModel?.currentWeight ?? ""
        let currentWater = viewModel?.currentWater ?? 0
        let firstWeight = viewModel?.firstWeight ?? ""
        

        let caloriesPercent = output.didGetPercent(target: targetCal, current: currentCal)
        let caloriesPart = output.didGetPart(target: targetCal, current: currentCal)
        
        let targetWater = output.didGetTargetWater(currentWater: Double(currentWeight) ?? 0)
        let dblCurrentWater = Double(currentWater)
        let dblTargetWater = Double(targetWater)
        let waterPercent = output.didGetPercent(target: dblTargetWater, current: dblCurrentWater)
        let waterPart = output.didGetPart(target: dblTargetWater, current: dblCurrentWater)
        
        let dblCurrentWeight = Double(currentWeight) ?? 0
              let dblFirstWeight = Double(firstWeight) ?? 0
        
        let weightDifference = output.didGetDifference(currentWeight: dblCurrentWeight, firstWeight: dblFirstWeight)
        var stringDifference: String
        var weightPercent: Float = 0.0
        var weightColor: String
        if weightDifference > 0 {
            stringDifference = "+" + "\(weightDifference)"
            weightColor = "Red"
        } else if weightDifference < 0 {
            stringDifference = "\(weightDifference)"
            weightPercent = 100.0
            weightColor = "Green"
        } else {
            stringDifference = "\(weightDifference)"
            weightColor = "Green"
        }
        if indexPath == IndexPath(item: 0, section: 0) {
            output.countTotalPercent(waterPercent: waterPercent,
                                     caloriesPercent: caloriesPercent,
                                     weightPercent: weightPercent)
            output.countTotalTasks(waterPercent: waterPercent,
                                   caloriesPercent: caloriesPercent,
                                   weightPercent: weightPercent)
        }
        
        
        switch indexPath.item {
        case 0:
            cell.configure(category: "Калории",
                           target: "\(targetCal) ккал",
                           result: "\(currentCal) ккал",
                           percent: "\(caloriesPercent)%",
                           color: "Orange",
                           valueOfprogress: caloriesPart)
        case 1:
            cell.configure(category: "Вес",
                           target: "\(targetWeight) кг",
                           result: "\(currentWeight) кг",
                           percent: "\(stringDifference) кг",
                           color: weightColor,
                           valueOfprogress: 1)
        case 2:
            cell.configure(category: "Вода",
                           target: "\(targetWater) литра",
                           result: "\(currentWater) литра",
                           percent: "\(waterPercent)%",
                           color: "Blue",
                           valueOfprogress: waterPart)
        default:
            break
        }
        
        return cell
    }
    
    
}

