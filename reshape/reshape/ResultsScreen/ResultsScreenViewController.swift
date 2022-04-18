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
    }
}

extension ResultsScreenViewController: ResultsScreenViewInput {
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
    private func setupUI(){
        view.backgroundColor = .white
        mainView.setupGradient(withColor: [UIColor.lightVioletColor!.cgColor,
                                           UIColor.darkVioletColor!.cgColor])
        mainView.verticalGradient()
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
            print("вода")
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
        
        switch indexPath.item {
        case 0:
            cell.configure(category: "Калории",
                           target: "2000 ккал",
                           result: "1000 ккал",
                           percent: "50%",
                           color: "Orange",
                           valueOfprogress: 0.5)
        case 1:
            cell.configure(category: "Вес",
                           target: "50 кг",
                           result: "52 кг",
                           percent: "-200г",
                           color: "Green",
                           valueOfprogress: 1)
        case 2:
            cell.configure(category: "Вода",
                           target: "2 литра",
                           result: "1,25 литра",
                           percent: "62%",
                           color: "Blue",
                           valueOfprogress: 0.62)
        default:
            break
        }
        
        return cell
    }
    
    
}
