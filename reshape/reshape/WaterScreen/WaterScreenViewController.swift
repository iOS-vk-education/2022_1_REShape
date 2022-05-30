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
    private var lastData = "0"

    init(output: WaterScreenViewOutput) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    let backButton: EnterButton = EnterButton()

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
        setupNavigation()
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
        let heightFrame = view.frame.height - 150.0
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
}

extension WaterScreenViewController: WaterScreenViewInput {
    func updateCollectionView() {
        waterCollectionView.reloadData()
        mainView.changeState()
    }
    
    private func setupConstraints(){
        view.addSubview(waterScrollView)
        waterScrollView.top(isIncludeSafeArea: false)
        waterScrollView.leading()
        waterScrollView.trailing()
        waterScrollView.addSubview(mainView)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: waterScrollView.topAnchor).isActive = true
        mainView.leading()
        mainView.trailing()
        mainView.height(view.bounds.height / 2.8)
        
        waterScrollView.addSubview(informHeaderLabel)
        NSLayoutConstraint.activate([
            informHeaderLabel.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 16)
        ])
        informHeaderLabel.leading(33)
        
        waterScrollView.addSubview(waterCollectionView)
        NSLayoutConstraint.activate([
            waterCollectionView.topAnchor.constraint(equalTo: informHeaderLabel.bottomAnchor, constant: 16)
        ])
        waterCollectionView.centerX()
        waterCollectionView.leading()
        waterCollectionView.trailing()
        waterCollectionView.height(view.bounds.height / 2.5)
        
        waterScrollViewConstraint = waterScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        waterScrollViewConstraint?.isActive = true
        waterScrollView.delegate = self
    }
    
    func setupUI() {
        view.backgroundColor = .white
        mainView.layer.shadowOffset = CGSize(width: 4, height: 4)
        mainView.layer.shadowRadius = 5
        mainView.layer.shadowOpacity = 0.5
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        waterCollectionView.register(cellType: WaterCollectionCell.self)
        waterCollectionView.dataSource = self
        output.requestData()
    }
    
    private func setupNavigation() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func sendData() {
        let water = (waterCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? WaterCollectionCell)?.volumeTextField.text ?? lastData
        let coffee = (waterCollectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? WaterCollectionCell)?.volumeTextField.text ?? lastData
        let tea = (waterCollectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? WaterCollectionCell)?.volumeTextField.text ?? lastData
        let fizzy = (waterCollectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as? WaterCollectionCell)?.volumeTextField.text ?? lastData
        let milk = (waterCollectionView.cellForItem(at: IndexPath(item: 4, section: 0)) as? WaterCollectionCell)?.volumeTextField.text ?? lastData
        let alco = (waterCollectionView.cellForItem(at: IndexPath(item: 5, section: 0)) as? WaterCollectionCell)?.volumeTextField.text ?? lastData
        let juice = (waterCollectionView.cellForItem(at: IndexPath(item: 6, section: 0)) as? WaterCollectionCell)?.volumeTextField.text ?? lastData
        output.send(water: water, coffee: coffee, tea: tea, fizzy: fizzy, milk: milk, alco: alco, juice: juice)
    }
}

extension WaterScreenViewController: UICollectionViewDelegateFlowLayout {
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

extension WaterScreenViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
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
        cell.volumeTextField.delegate = self
        switch indexPath.item {
            case 0:
                cell.layer.cornerRadius = 10
                cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                cell.configure(cup: UIImage(named: "StillWater")!,
                               water: "Вода",
                               volume: output.getWater())
            case 1:
                cell.configure(cup: UIImage(named: "Coffee")!,
                               water: "Кофе",
                               volume: output.getCoffee())
            case 2:
                cell.configure(cup: UIImage(named: "Tea")!,
                               water: "Чай",
                               volume: output.getTea())
            case 3:
                cell.configure(cup: UIImage(named: "SparklingWater")!,
                               water: "Газированная вода",
                               volume: output.getFizzy())
            case 4:
                cell.configure(cup: UIImage(named: "Milk")!,
                               water: "Молоко",
                               volume: output.getMilk())
            case 5:
                cell.configure(cup: UIImage(named: "Alcohol")!,
                               water: "Алкоголь",
                               volume: output.getAlco())
            case 6:
                cell.layer.cornerRadius = 10
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.configure(cup: UIImage(named: "Juice")!,
                               water: "Сок",
                               volume: output.getJuice())
            default:
                break
            }
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? WaterCollectionCell else { return }
        cell.tapped()
    }
}

extension WaterScreenViewController: CustomWaterDelegate{
    func getTotal() -> Int {
        return output.getTotal()
    }
    
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

extension WaterScreenViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if Int(textField.text ?? "") == nil {
            textField.text = self.lastData
        }
        self.sendData()
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
