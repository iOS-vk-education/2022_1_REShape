//
//  WaterScreenViewController.swift
//  reshape
//
//  Created by Полина Константинова on 30.03.2022.
//
//

import UIKit


final class WaterScreenViewController: UIViewController, UIGestureRecognizerDelegate {
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
        informHeaderLabel.text = "Выпито сегодня:"
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
    
    private let waterScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var waterScrollViewConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupUI()
        setupCollectionView()
        mainView.delegate = self
        addGestureRecognizer()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupObserversForKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsetupObserversForKeyboard()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightFrame = view.frame.height - 125
        let widthFrame = view.frame.width
        waterScrollView.contentSize = CGSize(width: widthFrame, height: heightFrame)
    
    }
}

extension WaterScreenViewController {
    private func setupObserversForKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func unsetupObserversForKeyboard(){
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: self.view.window)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: self.view.window)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.waterScrollViewConstraint?.constant == 0 {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.waterScrollViewConstraint?.constant -= keyboardFrame.height
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.waterScrollViewConstraint?.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
    @objc
    func endEditing() {
        view.endEditing(true)
    }
}

extension WaterScreenViewController: WaterScreenViewInput {
    private func setupConstraints(){
        view.addSubview(waterScrollView)
        waterScrollView.top(isIncludeSafeArea: false)
        waterScrollView.leading(0)
        waterScrollView.trailing(0)
        
        waterScrollView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.top(isIncludeSafeArea: false)
        mainView.leading()
        mainView.trailing()
        mainView.height(view.bounds.height / 2.5)
        
        waterScrollView.addSubview(informHeaderLabel)
        NSLayoutConstraint.activate([
            informHeaderLabel.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 21)
        ])
        informHeaderLabel.leading(33)
        
        waterScrollView.addSubview(waterCollectionView)
        NSLayoutConstraint.activate([
            waterCollectionView.topAnchor.constraint(equalTo: informHeaderLabel.bottomAnchor, constant: 21)
        ])
        waterCollectionView.centerX()
        waterCollectionView.leading()
        waterCollectionView.trailing()
        waterCollectionView.height(view.bounds.height / 2.5)
        
        waterScrollViewConstraint = waterScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        waterScrollViewConstraint?.isActive = true
    }
    
    func setupUI() {
        view.backgroundColor = .white
        mainView.layer.masksToBounds = false
        mainView.layer.shadowOffset = CGSize(width: 4, height: 4)
        mainView.layer.shadowRadius = 5
        mainView.layer.shadowOpacity = 0.5
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        waterCollectionView.register(cellType: WaterCollectionCell.self)
        waterCollectionView.dataSource = self
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
                cell.configure(cup: UIImage(named: "StillWater")!,
                               water: "Вода",
                               volume: cell.volumeTextField.text ?? "500")
            case 1:
                cell.configure(cup: UIImage(named: "Coffee")!,
                               water: "Кофе",
                               volume: cell.volumeTextField.text ?? "500")
            case 2:
                cell.configure(cup: UIImage(named: "Tea")!,
                               water: "Чай",
                               volume: cell.volumeTextField.text ?? "500")
            case 3:
                cell.configure(cup: UIImage(named: "SparklingWater")!,
                               water: "Газированная вода",
                               volume: cell.volumeTextField.text ?? "500")
            case 4:
                cell.configure(cup: UIImage(named: "Milk")!,
                               water: "Молоко",
                               volume: "500")
            case 5:
                cell.configure(cup: UIImage(named: "Alcohol")!,
                               water: "Алкоголь",
                               volume: "500")
            case 6:
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.configure(cup: UIImage(named: "Juice")!,
                               water: "Сок",
                               volume: "500")
            default:
                break
            }

            return cell
        }
}

extension WaterScreenViewController: CustomWaterDelegate {
    func backButtonAction() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.mainView.backButton.alpha = 0.7
        } completion: { [weak self] finished in
            if finished {
                self?.output.backButtonPressed()
            }
        }
    }
}

extension WaterScreenViewController {
    func addGestureRecognizer() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTap)
    }

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        for i in 0...6{
            guard let cell = waterCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? WaterCollectionCell else {return}
            cell.unchosen()
        }
    }
}
