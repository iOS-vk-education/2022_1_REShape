//
//  ProfileScreenViewController.swift
//  reshape
//
//  Created by Полина Константинова on 30.03.2022.
//
//

import UIKit

final class ProfileScreenViewController: UIViewController {
    private let output: ProfileScreenViewOutput
    private let mainView: CustomViewProfile = CustomViewProfile()

    init(output: ProfileScreenViewOutput) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private let informHeaderLabel: UILabel = {
        let informHeaderLabel = UILabel()
        informHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        informHeaderLabel.text = "Информация о пользователе:"
        informHeaderLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        informHeaderLabel.textColor = .black
        informHeaderLabel.textAlignment = .left
        return informHeaderLabel
    }()
    private lazy var profileCollectionView: UICollectionView = {
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


extension ProfileScreenViewController: ProfileScreenViewInput {
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
        view.addSubview(profileCollectionView)
        NSLayoutConstraint.activate([
            profileCollectionView.topAnchor.constraint(equalTo: informHeaderLabel.bottomAnchor, constant: 21)
        ])
        profileCollectionView.centerX()
        profileCollectionView.leading()
        profileCollectionView.trailing()
        profileCollectionView.height(view.bounds.height / 2.5)

    }
    func setupUI() {
        view.backgroundColor = .white
        mainView.layer.masksToBounds = false
        mainView.layer.shadowOffset = CGSize(width: 4, height: 4)
        mainView.layer.shadowRadius = 5
        mainView.layer.shadowOpacity = 0.5
        

    }
    private func setupCollectionView(){
        profileCollectionView.register(cellType: ProfileCollectionCell.self)
    }
}

extension ProfileScreenViewController: UICollectionViewDelegateFlowLayout {
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

extension ProfileScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                            numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueCell(cellType: ProfileCollectionCell.self, for: indexPath)

        switch indexPath.item {
            case 0:
                cell.layer.cornerRadius = 10
                cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                cell.configure(category: "Пол",
                                inform: "жен")
            case 1:
                cell.configure(category: "Возраст",
                                inform: "20 лет")
            case 2:
                cell.configure(category: "Рост",
                                inform: "167 см")
            case 3:
                cell.configure(category: "Начальный вес",
                               inform: "54 кг")
            case 4:
                cell.layer.cornerRadius = 10
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.configure(category: "Цель по весу",
                               inform: "50 кг")
            default:
                break
            }

            return cell
        }
}



