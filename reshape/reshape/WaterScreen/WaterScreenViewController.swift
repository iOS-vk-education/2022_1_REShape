//
//  WaterScreenViewController.swift
//  reshape
//
//  Created by Полина Константинова on 30.03.2022.
//
//

import UIKit

final class WaterScreenViewController: UIViewController {
    private let output: WaterScreenViewOutput
    private let mainView: CustomWaterView = CustomWaterView()

    init(output: WaterScreenViewOutput) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private let informHeaderLabel: UILabel = {
        let informHeaderLabel = UILabel()
        informHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        informHeaderLabel.text = "Выпито:"
        informHeaderLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        informHeaderLabel.textColor = .black
        informHeaderLabel.textAlignment = .left
        return informHeaderLabel
    }()
    private lazy var waterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupUI()
        setupCollectionView()
        
    }
}


extension WaterScreenViewController: ProfileScreenViewInput {
    private func setupConstraints(){
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.top(isIncludeSafeArea: false)
        mainView.leading()
        mainView.trailing()
        mainView.height(view.bounds.height / 2.5)
        view.addSubview(informHeaderLabel)
        NSLayoutConstraint.activate([
            informHeaderLabel.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 21)
        ])
        informHeaderLabel.leading(33)
        view.addSubview(waterCollectionView)
        NSLayoutConstraint.activate([
            waterCollectionView.topAnchor.constraint(equalTo: informHeaderLabel.bottomAnchor, constant: 21)
        ])
        waterCollectionView.centerX()
        waterCollectionView.leading()
        waterCollectionView.trailing()
        waterCollectionView.height(view.bounds.height / 2.5)

    }
    func setupUI() {
        view.backgroundColor = .white
        mainView.layer.masksToBounds = false
        mainView.layer.shadowOffset = CGSize(width: 4, height: 4)
        mainView.layer.shadowRadius = 5
        mainView.layer.shadowOpacity = 0.5
        

    }
    private func setupCollectionView(){
        waterCollectionView.register(cellType: WaterCollectionCell.self)
    }
}

extension WaterScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 20,
                      height: view.frame.height / 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(1.0)
    }
}

extension WaterScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                            numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueCell(cellType: WaterCollectionCell.self, for: indexPath)

        switch indexPath.item {
            case 0:
                cell.layer.cornerRadius = 10
                cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            cell.configure(cup: UIImage(named: "Glass")!,
                           water: "Вода",
                           volume: "500 мл")
            case 1:
                cell.configure(cup: UIImage(named: "Gradient")!,
                               water: "Возраст",
                               volume: "500 мл")
            case 2:
                cell.configure(cup: UIImage(named: "Gradient")!,
                               water: "Рост",
                               volume: "500 мл")
            case 3:
                cell.configure(cup: UIImage(named: "Gradient")!,
                               water: "Начальный вес",
                               volume: "500 мл")
            case 4:
                cell.configure(cup: UIImage(named: "Gradient")!,
                               water: "Цель по весу",
                               volume: "500 мл")
            case 5:
                cell.configure(cup: UIImage(named: "Gradient")!,
                               water: "Начальный вес",
                               volume: "500 мл")
            case 6:
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.configure(cup: UIImage(named: "Gradient")!,
                               water: "Начальный вес",
                               volume: "500 мл")
            default:
                break
            }

            return cell
        }
}



