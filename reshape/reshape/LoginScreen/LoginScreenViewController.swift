//
//  LoginScreenViewController.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import UIKit

enum Labels: String {
    case email = "Почта"
    case password = "Пароль"
    case forgetPassword = "Введите почту"
}

enum Placeholders: String {
    case email = "abvgd@ya.ru"
    case password = "********"
}
let defaults = UserDefaults.standard
final class LoginScreenViewController: UIViewController {
    
    private lazy var closeButton: CloseButton = CloseButton(viewControllerToClose: self)
    private let mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = "Вход в аккаунт"
        mainLabel.textAlignment = .center
        mainLabel.textColor = UIColor.violetColor
        mainLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return mainLabel
    }()
    private let enterStackView: UIStackView = {
        let enterStackView = UIStackView()
        enterStackView.alignment = .center
        enterStackView.spacing = 19
        enterStackView.axis = .vertical
        return enterStackView
    }()
    
    private let rememberButton: UIImageView = {
        let rememberButton = UIImageView()
        rememberButton.translatesAutoresizingMaskIntoConstraints = false
        rememberButton.image = UIImage(named: "notRememberButton")
        //        rememberButton.setImage(UIImage(named: "notRememberButton"), for: .normal)
        return rememberButton
    }()
    private let rememberLabel: UILabel = {
        let rememberLabel: UILabel = UILabel()
        rememberLabel.translatesAutoresizingMaskIntoConstraints = false
        rememberLabel.text = "Запомнить меня"
        rememberLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        rememberLabel.textColor = .black
        return rememberLabel
    }()
    
    private let forgetPasswordButton: UILabel = {
        let forgetPasswordButton: UILabel = UILabel()
        forgetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgetPasswordButton.text = "Забыли пароль?"
        forgetPasswordButton.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        forgetPasswordButton.textColor = UIColor.violetColor
        forgetPasswordButton.attributedText = NSAttributedString(string: forgetPasswordButton.text ?? "", attributes:
                                                                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
        return forgetPasswordButton
    }()
    private let rememberPasswordStackView: UIStackView = {
        let rememberPasswordStackView = UIStackView()
        rememberPasswordStackView.translatesAutoresizingMaskIntoConstraints = false
        rememberPasswordStackView.spacing = 5
        rememberPasswordStackView.axis = .horizontal
        return rememberPasswordStackView
    }()
    
    private let emailStackView: AuthStackView = AuthStackView()
    private let passwordStackView: AuthStackView = AuthStackView()
    private let loginButton: EnterButton = EnterButton()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.modalViewGrayColor
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let defaultHeight: CGFloat = 406
    let dismissibleHeight: CGFloat = 200
    var currentContainerHeight: CGFloat = 300
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    private let output: LoginScreenViewOutput
    private lazy var isRemembered: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupObserversForKeyboard()
        unsetupObserversForKeyboard()
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    init(output: LoginScreenViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        setUpUI()
        setupPanGesture()
        emailStackView.delegate = self
        emailStackView.dataSource = self
        passwordStackView.delegate = self
        passwordStackView.dataSource = self
    }
    
    @objc
    func forgetPassword() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.output.showForgetPasswordScreen()
        }
        
    }
    @objc
    func login() {
        print("login pressed")
    }
}

extension LoginScreenViewController: LoginScreenViewInput {
}


extension LoginScreenViewController {
    private func setUpConstraints(){
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(mainLabel)
        containerView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        enterStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(enterStackView)
        
        emailStackView.translatesAutoresizingMaskIntoConstraints = false
        passwordStackView.translatesAutoresizingMaskIntoConstraints = false
        enterStackView.addArrangedSubview(emailStackView)
        enterStackView.addArrangedSubview(passwordStackView)
        
        containerView.addSubview(rememberPasswordStackView)
        rememberPasswordStackView.addArrangedSubview(rememberButton)
        rememberPasswordStackView.addArrangedSubview(rememberLabel)
        containerView.addSubview(forgetPasswordButton)
        
        containerView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        dimmedView.pins()
        
        mainLabel.pins(UIEdgeInsets(top: 26, left: 112, bottom: -354, right: -113))
        
        containerView.leading()
        containerView.trailing()
        
        closeButton.height(36)
        closeButton.width(36)
        closeButton.trailing(-34)
        
        enterStackView.leading(35)
        enterStackView.trailing(-34)
        enterStackView.height(149)
        
        emailStackView.leading()
        emailStackView.trailing()
        emailStackView.height(69)
        passwordStackView.leading()
        passwordStackView.trailing()
        
        rememberPasswordStackView.leading(35)
        rememberPasswordStackView.trailing(-34)
        rememberPasswordStackView.bottom(-135, isIncludeSafeArea: false)
        
        rememberButton.centerY()
        rememberButton.width(16)
        rememberButton.height(16)
        rememberLabel.centerY()
        
        forgetPasswordButton.leading(242)
        forgetPasswordButton.trailing(-32)
        
        loginButton.width(306)
        loginButton.height(55)
        loginButton.centerX()
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor),
            
            enterStackView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 26),
            
            rememberPasswordStackView.topAnchor.constraint(equalTo: enterStackView.bottomAnchor, constant: 27),
            rememberPasswordStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 35),
            rememberPasswordStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -135),
            
            forgetPasswordButton.topAnchor.constraint(equalTo: enterStackView.bottomAnchor, constant: 27),
            
            loginButton.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: 28),
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    private func setUpUI(){
        emailStackView.backgroundTFColor = .white
        emailStackView.tag = 0
        passwordStackView.tag = 1
        passwordStackView.backgroundTFColor = .white
        loginButton.setupUI(name: "Войти")
        rememberPasswordStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rememberPasswordButtonPressed)))
        forgetPasswordButton.isUserInteractionEnabled = true
        forgetPasswordButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgetPassword)))
        loginButton.action = {[weak self] in
            self?.view.endEditing(true)
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.loginButton.backgroundColor = UIColor.darkVioletColor
            } completion: { [weak self] finished in
                if finished {
                    guard let `self` = self else { return }
                    if finished {
                        let isEmpty = self.isFieldEmpty()
                        if isEmpty.count > 0 {
                            // появления алерта, если есть незаполненные поля
                            self.makeAlert("Заполните форму", "Пожалуйста, проверьте пустые поля: \(isEmpty.joined(separator: ", "))")
                        } else {
                            if let email = self.emailStackView.textField.text,
                               let password = self.passwordStackView.textField.text{
                                self.output.didCheckLogin(email: email, password: password){ error in
                                    DispatchQueue.main.async {
                                        if let error = error {
                                            self.makeAlert("Error", error)
                                        } else {
                                            self.output.loginDidTapped()
                                        }
                                    }
                                }

                            }
                        }
                        
                        self.loginButton.backgroundColor = UIColor.violetColor
                    }
                }
            }
        }
        closeButton.action = { [weak self] in
            self?.view.endEditing(true)
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.closeButton.alpha = 0.7
            } completion: { [weak self] finished in
                if finished {
                    self?.animateDismissView()
                    self?.closeButton.alpha = 1
                }
            }
        }
        closeButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    @objc
    func rememberPasswordButtonPressed() {
        print("remember password")
        if isRemembered == false {
            rememberButton.image = UIImage(named: "rememberButton")
            isRemembered = !isRemembered
            self.output.isUserRemembered(isRemembered: true, forKey: "isRemembered")
        } else {
            rememberButton.image = UIImage(named: "notRememberButton")
            isRemembered = !isRemembered
            self.output.isUserRemembered(isRemembered: false, forKey: "isRemembered")
        }
    }
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
        case .ended:
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            }
        default:
            break
        }
    }
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0.6
        }
    }
    func animateDismissView() {
        view.endEditing(true)
        dimmedView.alpha = 0.6
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.output.closeLoginScreen()
        }
        UIView.animate(withDuration: 0.4) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
    @objc func handleCloseAction() {
        UIView.animate(withDuration: 0.4){ [weak self] in
            self?.animateDismissView()
        }
        
    }
    private func setupObserversForKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsetupObserversForKeyboard(){
        NotificationCenter.default.removeObserver(self,
                                                   name: UIResponder.keyboardWillShowNotification,
                                                   object: self.view.window)
         NotificationCenter.default.removeObserver(self,
                                                   name: UIResponder.keyboardWillHideNotification,
                                                   object: self.view.window)
    }
    //поднятие вью при появлении клавы
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.containerViewBottomConstraint?.constant == 0 {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.containerViewBottomConstraint?.constant -= keyboardFrame.height
                self?.view.layoutIfNeeded()
            }
        }
    }
    //возвращение вью в обычное состояние
    @objc
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.containerViewBottomConstraint?.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
    func isFieldEmpty()->[String]{
        var emptyFields: [String] = [String]()
        if let email = emailStackView.textField.text,
           email.isEmpty,
           let label = emailStackView.label.text {
            emptyFields.append(label)
        }
        if let password = passwordStackView.textField.text,
           password.isEmpty,
           let label = passwordStackView.label.text{
            emptyFields.append(label)
        }
        return emptyFields
    }
}

extension LoginScreenViewController: AuthStackViewDelegate {
    func endEditingTextField(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension LoginScreenViewController: AuthStackViewDataSource {
    func addDoneButton(for tag: Int) -> UIView {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.isHidden = true
        return keyboardToolbar
    }
    
    func setupKeyType(for tag: Int) -> UIReturnKeyType {
        return UIReturnKeyType.default
    }
    
    func setupKeyboardType(for tag: Int) -> UIKeyboardType {
        return UIKeyboardType.default
    }
    
    
    func isSecurityEntryOn(for tag: Int) -> Bool {
        if tag == 0 {
            return false
        } else {
            return true
        }
    }
    
    func labelText(tag: Int) -> String {
        var returnLabel: String
        switch tag {
        case 0:
            returnLabel = Labels.email.rawValue
        case 1:
            returnLabel = Labels.password.rawValue
        case 2:
            returnLabel = Labels.forgetPassword.rawValue
        default:
            returnLabel = ""
        }
        return returnLabel
    }
    
    func placeholderText(tag: Int) -> String {
        if tag == 0 {
            return Placeholders.email.rawValue
        } else {
            return Placeholders.password.rawValue
        }
    }
}



