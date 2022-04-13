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

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    private let registrationScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let registrationView: RegistrationContentView = {
        let registrationView = RegistrationContentView()
        registrationView.translatesAutoresizingMaskIntoConstraints = false
        return registrationView
    }()
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
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightFrame = registrationView.frame.height
        let widthFrame = view.frame.width
        registrationScrollView.contentSize = CGSize(width: widthFrame, height: heightFrame)
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
        
        view.addSubview(registrationScrollView)
        NSLayoutConstraint.activate([
            registrationScrollView.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 5)
        ])
        registrationScrollView.leading(0)
        registrationScrollView.trailing(0)
        registrationScrollView.bottom(isIncludeSafeArea: true)
        registrationScrollView.centerX()
        
        registrationScrollView.addSubview(contentView)
        contentView.top(isIncludeSafeArea: false)
        contentView.leading()
        contentView.trailing()
        contentView.bottom(isIncludeSafeArea: false)
        
        contentView.addSubview(registrationView)
        registrationView.top(isIncludeSafeArea: false)
        registrationView.leading(35)
        registrationView.trailing(-35)
        registrationView.bottom(isIncludeSafeArea: false)
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

    private func setupObserversForKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
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
    @objc
    func endEditing() {
        view.endEditing(true)
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


extension RegisterScreenViewController: RegisterScreenViewInput {
}



extension RegisterScreenViewController: AuthStackViewDelegate {
    func endEditingTextField(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}


extension RegisterScreenViewController: AuthStackViewDataSource {
    
    
    func addDoneButton(for tag: Int) -> UIView {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self, action: #selector(endEditing))
        keyboardToolbar.items = [doneBarButton]
        return keyboardToolbar
        
    }
    
    func setupKeyType(for tag: Int) -> UIReturnKeyType {
        switch tag {
        case 2...5:
            return UIReturnKeyType.continue
        default:
            return UIReturnKeyType.default
        }
    }
    
    func setupKeyboardType(for tag: Int) -> UIKeyboardType {
        switch tag {
        case 2...5:
            return UIKeyboardType.numberPad
        default:
            return UIKeyboardType.default
        }
    }
    
    
    
    func isSecurityEntryOn(for tag: Int) -> Bool {
        return false
    }
    
    func labelText(tag: Int) -> String {
        return RegistrationLabels.allCases[tag - 1].rawValue
        
    }
    
    func placeholderText(tag: Int) -> String {
        return RegistrationPlaceholders.allCases[tag - 1].rawValue
    }
}
