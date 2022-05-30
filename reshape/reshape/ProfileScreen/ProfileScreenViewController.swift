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
    private var imagePicker: ImagePicker?
    private let mainView: CustomProfileView = CustomProfileView()
    

    init(output: ProfileScreenViewOutput) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var addPhoto: UIImageView = {
        var photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()

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
        mainView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.requestUploadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addPhoto.layer.cornerRadius = addPhoto.frame.size.height / 2
        addPhoto.layer.masksToBounds = true
        
        if addPhoto.image == nil {
            addPhoto.image = UIImage(named: "person")
        }
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
            informHeaderLabel.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 16)
        ])
        informHeaderLabel.leading(33)
        
        view.addSubview(profileCollectionView)
        NSLayoutConstraint.activate([
            profileCollectionView.topAnchor.constraint(equalTo: informHeaderLabel.bottomAnchor, constant: 16)
        ])
        profileCollectionView.centerX()
        profileCollectionView.leading()
        profileCollectionView.trailing()
        profileCollectionView.height(view.bounds.height / 2.5)
        
        view.addSubview(addPhoto)
        
        NSLayoutConstraint.activate([
            addPhoto.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        ])
        addPhoto.centerX()
        
        addPhoto.top(85, isIncludeSafeArea: false)
        addPhoto.height(119)
        addPhoto.width(119)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        mainView.setupGradientColor(withColor: [UIColor.lightVioletColor.cgColor,
                                                UIColor.darkVioletColor.cgColor])
        mainView.setupGradientDirection(withDirection: .topToDown)
        mainView.layer.masksToBounds = false
        mainView.layer.shadowOffset = CGSize(width: 4, height: 4)
        mainView.layer.shadowRadius = 5
        mainView.layer.shadowOpacity = 0.5
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        addPhoto.isUserInteractionEnabled = true
        addPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                             action: #selector(selectPhoto)))

    }
    
    func updateInform() {
        mainView.setNameForProfileScreen(setName: output.getName() + output.getSurname())
        mainView.setEmailForProfileScreen(setEmail: output.getEmail())
//        self.addPhoto.loadImage(photoURL: output.getPhotoURL() ?? nil)
    }
    
    @objc func selectPhoto(){
        imagePicker?.present(from: addPhoto)
    }
    
    private func setupCollectionView(){
        profileCollectionView.register(cellType: ProfileCollectionCell.self)
    }
}

extension ProfileScreenViewController: ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        self.addPhoto.image = image
    }
}

extension ProfileScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 30,
                      height: view.frame.height / 24)
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
                               inform: output.getGender())
            case 1:
                cell.configure(category: "Возраст",
                               inform: output.getAge())
            case 2:
                cell.configure(category: "Рост",
                               inform: output.getHeight())
            case 3:
                cell.configure(category: "Начальный вес",
                               inform: output.getStartWeight())
            case 4:
                cell.layer.cornerRadius = 10
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.configure(category: "Цель по весу",
                               inform: output.getTargetWeight())
            default:
                break
            }
            return cell
        }
}

extension ProfileScreenViewController: CustomProfileDelegate {
    func quitButtonAction() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.mainView.quitButton.alpha = 0.7
        } completion: { [weak self] finished in
            if finished {
                self?.output.quitButtonPressed()
                self?.output.didLogOut()
            }
        }
    }
}
