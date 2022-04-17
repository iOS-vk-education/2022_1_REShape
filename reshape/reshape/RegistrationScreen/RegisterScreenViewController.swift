//
//  RegisterScreenViewController.swift
//  reshape
//
//  Created by Veronika on 04.04.2022.
//  
//

import UIKit


final class RegisterScreenViewController: UIViewController {
    
    ///текст для полей лейблов
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
    
    ///текст для плейсхолдеров текстовых полей
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
    
    ///кастомный навигейшн бар
    private let customNavigationBarView: NavigationBarView = {
        let navBar = NavigationBarView()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    ///вью для добавления фотографии пользователя
    private var addPhoto: UIImageView = {
        var photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    /// лейбл под фотографией
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
    private var registrationScrollViewConstraint: NSLayoutConstraint?
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
        unsetupObserversForKeyboard()
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
        //установление размеров скрол вью
        registrationScrollView.contentSize = CGSize(width: widthFrame, height: heightFrame)
        
        // скругление углов имадж вью
        addPhoto.layer.cornerRadius = addPhoto.frame.size.height / 2
        addPhoto.layer.masksToBounds = true
        
        // если пользователь зашел в установку фото, но вышел ничего не выбрав установится дефолтная фотография
        if addPhoto.image == nil {
            addPhoto.image = UIImage(named: "Add")
        }
    }
}

extension RegisterScreenViewController {
    
    /// настройка отступов
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
        
        registrationScrollView.addSubview(contentView)
        contentView.top(isIncludeSafeArea: false)
        contentView.leading(35)
        contentView.trailing(-35)
        contentView.bottom(isIncludeSafeArea: false)
        
        contentView.addSubview(registrationView)
        registrationView.top(isIncludeSafeArea: false)
        registrationView.leading()
        registrationView.trailing()
        registrationView.bottom(isIncludeSafeArea: false)
        
        registrationScrollViewConstraint = registrationScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        registrationScrollViewConstraint?.isActive = true
        
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        customNavigationBarView.delegate = self
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        addPhoto.isUserInteractionEnabled = true
        addPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                             action: #selector(selectPhoto)))
        
        registrationView.dataSource = self
        
        //добавление экшна на кнопку
        registrationView.registrationButton.action = {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.registrationView.registrationButton.backgroundColor = UIColor.darkVioletColor
            } completion: { [weak self] finished in
                guard let `self` = self else { return }
                if finished {
                    let isEmpty = self.registrationView.isFieldEmpty()
                    if isEmpty.count > 0 {
                        // появления алерта, если есть незаполненные поля
                        self.makeAlert("Заполните форму", "Пожалуйста, проверьте пустые поля: \(isEmpty.joined(separator: ", "))")
                    } else {
                        guard let imageData = self.addPhoto.image?.jpegData(compressionQuality: 0.4) else {
                            return
                        }
                        
                        if let gender = self.registrationView.genderStackView.genderText,
                            let name = self.registrationView.stackViews[0].textField.text,
                           let surname = self.registrationView.stackViews[1].textField.text,
                           let age = self.registrationView.stackViews[2].textField.text,
                           let height = self.registrationView.stackViews[3].textField.text,
                           let weight = self.registrationView.stackViews[4].textField.text,
                           let target = self.registrationView.stackViews[5].textField.text,
                           let email = self.registrationView.stackViews[6].textField.text,
                           let password = self.registrationView.stackViews[7].textField.text{
                                self.output.didRegisterUser(photo: imageData,
                                                        gender: gender,
                                                        name: name,
                                                        surname: surname,
                                                        age: age,
                                                        height: height,
                                                        weight: weight,
                                                        target: target,
                                                        email: email,
                                                        password: password){ error in
                                DispatchQueue.main.async {
                                    if let error = error {
                                        self.makeAlert("Error", error)
                                    } else {
                                        self.output.registerDidTap()
                                    }
                                    
                                }
                            }
                        }
                        self.registrationView.registrationButton.backgroundColor = UIColor.violetColor
                    }
                }
            }
        }
    }
    
    @objc
    func selectPhoto(){
        imagePicker?.present(from: addPhoto)
    }
    
    /// добавление обсерверов для клавиатуры
    private func setupObserversForKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    /// удаление обсерверов для клавиатуры
    private func unsetupObserversForKeyboard(){
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: self.view.window)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: self.view.window)
    }
    /// поднятие вью при появлении клавиатуры
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        print(keyboardFrame.height)
        if self.registrationScrollViewConstraint?.constant == 0 {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.registrationScrollViewConstraint?.constant -= keyboardFrame.height
                self?.view.layoutIfNeeded()
            }
        }
    }
    ///возвращение вью в обычное состояние
    @objc
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.registrationScrollViewConstraint?.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
    @objc
    func endEditing() {
        view.endEditing(true)
    }
    
}


extension RegisterScreenViewController: NavigationBarDelegate{
    /// нажатие кнопки назад, переход на предыдущий экран
    func backButtonAction() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.customNavigationBarView.backButton.alpha = 0.7
        } completion: { [weak self] finished in
            if finished {
                self?.output.backButtonPressed()
                
            }
        }
    }
}

extension RegisterScreenViewController: ImagePickerDelegate{
    /// выбор фото
    func didSelect(image: UIImage?) {
        self.addPhoto.image = image
    }
}


extension RegisterScreenViewController: RegisterScreenViewInput {
}



extension RegisterScreenViewController: RegistrationContentViewDelegate {
    func endEditingTextField(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}


extension RegisterScreenViewController: AuthStackViewDataSource {
    
    /// кнопка Done для клаиатуры
    func addDoneButton(for tag: Int) -> UIView {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self, action: #selector(endEditing))
        keyboardToolbar.items = [doneBarButton]
        return keyboardToolbar
        
    }
    
    /// настройка необходимого типа клавиатуры
    func setupKeyboardType(for tag: Int) -> UIKeyboardType {
        switch tag {
        case 3...6:
            return UIKeyboardType.numberPad
        default:
            return UIKeyboardType.default
        }
    }
    
    /// натсройка безопасного ввода текста
    func isSecurityEntryOn(for tag: Int) -> Bool {
        if tag == 8 {
            return true
        } else {
            return false
        }
    }
    
    /// проставления текста в лейбл
    func labelText(tag: Int) -> String {
        return RegistrationLabels.allCases[tag - 1].rawValue
        
    }
    
    /// проставление текста в плейсхолдер
    func placeholderText(tag: Int) -> String {
        return RegistrationPlaceholders.allCases[tag - 1].rawValue
    }
}
