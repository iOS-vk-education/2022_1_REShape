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

final class LoginScreenViewController: UIViewController {
    
    private lazy var closeButton: CloseButton = CloseButton(viewControllerToClose: self)
    
    private let mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = "Вход в аккаунт"
        mainLabel.textAlignment = .center
        mainLabel.textColor = UIColor(named: "Violet")
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
    
    private let rememberButton: UIButton = {
        let rememberButton = UIButton()
        rememberButton.translatesAutoresizingMaskIntoConstraints = false
        rememberButton.setImage(UIImage(named: "notRememberButton"), for: .normal)
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
        forgetPasswordButton.textColor = UIColor(named: "Violet")
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
    
    private let emailStackView: CustomStackView = CustomStackView()
    private let passwordStackView: CustomStackView = CustomStackView()
    private let loginButton: EnterButton = EnterButton()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(named: "ModalViewColor")
        view.layer.cornerRadius = 40
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
    let maximumContainerHeight: CGFloat = 406
    var currentContainerHeight: CGFloat = 300
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    private let output: LoginScreenViewOutput
    private lazy var isRemembered: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        setupPanGesture()
        emailStackView.delegate = self
        emailStackView.dataSource = self
        passwordStackView.delegate = self
        passwordStackView.dataSource = self
        forgetPasswordButton.isUserInteractionEnabled = true
        forgetPasswordButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgetPassword)))
        loginButton.action = {[weak self] in
            self?.view.endEditing(true)
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.loginButton.backgroundColor = UIColor(named: "Violet Pressed")
            } completion: { [weak self] finished in
                if finished {
                    print("loginbutton tapped")
                    self?.loginButton.backgroundColor = UIColor(named: "Violet")
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
        
        NSLayoutConstraint.activate([
            
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 26),
            mainLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 112),
            mainLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -113),
            mainLabel.heightAnchor.constraint(equalToConstant: 26),
            
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            closeButton.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -34),
            
            enterStackView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 26),
            enterStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 35),
            enterStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -34),
            enterStackView.heightAnchor.constraint(equalToConstant: 149),
            
            emailStackView.leadingAnchor.constraint(equalTo: enterStackView.leadingAnchor),
            emailStackView.trailingAnchor.constraint(equalTo: enterStackView.trailingAnchor),
            emailStackView.heightAnchor.constraint(equalToConstant: 69),
            
            passwordStackView.leadingAnchor.constraint(equalTo: enterStackView.leadingAnchor),
            passwordStackView.trailingAnchor.constraint(equalTo: enterStackView.trailingAnchor),
            
            rememberPasswordStackView.topAnchor.constraint(equalTo: enterStackView.bottomAnchor, constant: 27),
            rememberPasswordStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 35),
            rememberPasswordStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -135),
            
            rememberButton.centerYAnchor.constraint(equalTo: rememberPasswordStackView.centerYAnchor),
            rememberButton.widthAnchor.constraint(equalToConstant: 16),
            rememberButton.heightAnchor.constraint(equalToConstant: 16),
            
            rememberLabel.centerYAnchor.constraint(equalTo: rememberPasswordStackView.centerYAnchor),
            
            forgetPasswordButton.topAnchor.constraint(equalTo: enterStackView.bottomAnchor, constant: 27),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -32),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 242),
            
            loginButton.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: 28),
            loginButton.heightAnchor.constraint(equalToConstant: 55),
            loginButton.widthAnchor.constraint(equalToConstant: 306),
            loginButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    private func setUpUI(){
        emailStackView.tag = 0
        passwordStackView.tag = 1
        passwordStackView.textField.isSecureTextEntry = true
        loginButton.setupUI(name: "Войти")
        rememberPasswordStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rememberPasswordButtonPressed)))
    }
    @objc
    func rememberPasswordButtonPressed() {
        print("remember password")
        if isRemembered == false {
            rememberButton.setImage(UIImage(named: "rememberButton"), for: .normal)
            isRemembered = !isRemembered
        } else {
            rememberButton.setImage(UIImage(named: "notRememberButton"), for: .normal)
            isRemembered = !isRemembered
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
}

extension LoginScreenViewController: CustomStackViewDelegate {
    func endEditingTextField(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension LoginScreenViewController: CustomStackViewDataSource {
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



