//
//  RegisterScreenViewController.swift
//  reshape
//
//  Created by Veronika on 04.04.2022.
//  
//

import UIKit


final class RegisterScreenViewController: UIViewController {
    
    private enum RegistrationLabels: String, CaseIterable {
        case name = "Имя"
        case surname = "Фамилия"
        case age = "Возраст"
        case height = "Рост"
        case weight = "Вес"
        case target = "Цель"
        case email = "Почта"
        case password = "Пароль"
    }
    
    private enum RegistrationPlaceholders: String, CaseIterable {
        case name = "Введите свое имя"
        case surname = "Введите свою фамилию"
        case age = "Введите свой возраст"
        case height = "Введите свой рост"
        case weight = "Укажите начальный вес"
        case target = "Укажите желаемый вес"
        case email = "Введите свою почту"
        case password = "Придумайте пароль"
    }

    private let output: RegisterScreenViewOutput
    private let customNavigationBarView: NavigationBarView = {
        let navBar = NavigationBarView()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    private var addPhoto: UIImageView = {
        var photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    private let photoLabel: UILabel = {
        let photoLabel = UILabel()
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        photoLabel.text = "Добавьте вашу фотографию или сделайте это позже"
        photoLabel.textAlignment = .center
        photoLabel.numberOfLines = 0
        photoLabel.textColor = UIColor.violetColor
        photoLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return photoLabel
    }()
    private let registrationTableView: UITableView = UITableView()
    private var registrationTableBottomConstraint: NSLayoutConstraint?
    private var imagePicker: ImagePicker?
    
    init(output: RegisterScreenViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupObserversForKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupUI()
        setupTableView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addPhoto.layer.cornerRadius = addPhoto.frame.size.height / 2
        addPhoto.layer.masksToBounds = true
        if addPhoto.image == nil {
            addPhoto.image = UIImage(named: "Add")
        }
    }
}

extension RegisterScreenViewController {
    private func setupConstraints(){
        view.addSubview(customNavigationBarView)
        customNavigationBarView.top(isIncludeSafeArea: false)
        customNavigationBarView.leading()
        customNavigationBarView.trailing()
        customNavigationBarView.height(80)
        
        view.addSubview(addPhoto)
        addPhoto.centerX()
        addPhoto.top(104, isIncludeSafeArea: false)
        addPhoto.height(130)
        addPhoto.width(130)
        
        view.addSubview(photoLabel)
        photoLabel.leading(79)
        photoLabel.trailing(-78)
        NSLayoutConstraint.activate([
            photoLabel.topAnchor.constraint(equalTo: addPhoto.bottomAnchor, constant: 5)
        ])
        
        view.addSubview(registrationTableView)
        registrationTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registrationTableView.topAnchor.constraint(equalTo: photoLabel.bottomAnchor,
                                                       constant: 5)
        ])
        registrationTableView.leading(35)
        registrationTableView.trailing(-34)
        registrationTableView.bottom(isIncludeSafeArea: false)
        registrationTableBottomConstraint = registrationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        registrationTableBottomConstraint?.isActive = true
        
    }
    private func setupUI(){
        view.backgroundColor = .white
        customNavigationBarView.delegate = self
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        addPhoto.isUserInteractionEnabled = true
        addPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                             action: #selector(selectPhoto)))
        
    }
    
    @objc
    func selectPhoto(){
        imagePicker?.present(from: addPhoto)
    }
    private func setupTableView(){
        registrationTableView.delegate = self
        registrationTableView.dataSource = self
        registrationTableView.rowHeight = 80
//        registrationTableView.
        registrationTableView.allowsSelection = false
        registrationTableView.register(StackViewCell.self)
        registrationTableView.register(GenderCell.self)
        registrationTableView.register(ButtonCell.self)
        registrationTableView.separatorStyle = .none
        registrationTableView.showsVerticalScrollIndicator = false
    }
    private func setupObserversForKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.registrationTableBottomConstraint?.constant == 0 {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.registrationTableBottomConstraint?.constant -= keyboardFrame.height
                self?.view.layoutIfNeeded()
            }
        }
    }
    //возвращение вью в обычное состояние
    @objc
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.registrationTableBottomConstraint?.constant = 0
            self?.view.layoutIfNeeded()
        }
    }

}


extension RegisterScreenViewController: NavigationBarDelegate{
    func backButtonAction() {
        output.backButtonPressed()
    }
}

extension RegisterScreenViewController: ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        self.addPhoto.image = image
    }
}

extension RegisterScreenViewController: UITableViewDelegate{
    
}

extension RegisterScreenViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = registrationTableView.dequeueCell(cellType: GenderCell.self, for: indexPath)
            return cell
        case 1...8:
            let cell = registrationTableView.dequeueCell(cellType: StackViewCell.self, for: indexPath)
            cell.tag = indexPath.row - 1
            cell.dataSource = self
            cell.delegate = self
            return cell
        case 9:
            let cell = registrationTableView.dequeueCell(cellType: ButtonCell.self, for: indexPath)
            cell.action = {[weak self] in
                self?.view.endEditing(true)
                UIView.animate(withDuration: 0.4) {
                    cell.registerButton.backgroundColor = .darkVioletColor
                } completion: { [weak self] finished in
                    if finished {
                        self?.output.registerDidTap()
                        cell.registerButton.backgroundColor = .violetColor
                    }
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }


}

extension RegisterScreenViewController: RegisterScreenViewInput {
}

extension RegisterScreenViewController: AuthStackViewCellDelegate {
    func endEditingTextField(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
}
extension RegisterScreenViewController: AuthStackViewDataSource {
    func isSecurityEntryOn(for tag: Int) -> Bool {
        return false
    }
    
    func labelText(tag: Int) -> String {
        return RegistrationLabels.allCases[tag].rawValue

    }
    
    func placeholderText(tag: Int) -> String {
        return RegistrationPlaceholders.allCases[tag].rawValue
    }
}
