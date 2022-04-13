//
//  ForgetPasswordScreenViewController.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import UIKit

final class ForgetPasswordScreenViewController: UIViewController {
    
    private let output: ForgetPasswordScreenViewOutput
    
    weak var delegate: (AuthStackViewDelegate)?
    weak var dataSource: (AuthStackViewDataSource)?
    private lazy var closeButton: CloseButton = CloseButton(viewControllerToClose: self)
    
    private let mainLabel: UILabel = {
        let mainLabel: UILabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = "Восстановление пароля"
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        mainLabel.textColor = UIColor.violetColor
        return mainLabel
    }()
    private let emailStackView: AuthStackView = AuthStackView()
    
    
    private let addtitionalLabel: UILabel = {
        let additionalLabel: UILabel = UILabel()
        additionalLabel.text = "Вам на почту придет код, с помощью которого Вы сможете восстановить пароль"
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.numberOfLines = 0
        additionalLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        additionalLabel.textAlignment = .left
        return additionalLabel
    }()
    private let restoreButton: EnterButton = EnterButton()
    
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        raiseViewWithKeyboard()
        dropDownViewWithoutKeyboard()
        animateShowDimmedView()
        animatePresentContainer()
    }
    init(output: ForgetPasswordScreenViewOutput) {
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
        emailStackView.delegate = self
        emailStackView.dataSource = self
        setupPanGesture()
    }
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
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.containerViewBottomConstraint?.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
}

extension ForgetPasswordScreenViewController{
    private func setUpConstraints(){
        
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(mainLabel)
        containerView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(emailStackView)
        emailStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(addtitionalLabel)
        restoreButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(restoreButton)
        
        dimmedView.pins()
        
        containerView.leading()
        containerView.trailing()
        
        mainLabel.leading(69)
        mainLabel.trailing(-64)
        mainLabel.height(26)
        
        closeButton.height(36)
        closeButton.width(36)
        closeButton.trailing(-34)
        
        emailStackView.leading(35)
        emailStackView.trailing(-34)
        emailStackView.height(69)
        
        addtitionalLabel.leading(35)
        addtitionalLabel.trailing(-34)
        
        restoreButton.width(306)
        restoreButton.height(55)
        restoreButton.centerX()
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 26),
            
            closeButton.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor),
            
            emailStackView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 26),
            
            addtitionalLabel.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 9),
            
            restoreButton.topAnchor.constraint(equalTo: addtitionalLabel.bottomAnchor, constant: 38),
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    private func setUpUI(){
        emailStackView.tag = 2
        restoreButton.setupUI(name: "Восстановить")
        closeButton.isUserInteractionEnabled = true
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
        emailStackView.backgroundTFColor = UIColor.white
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
        self.view.endEditing(true)
        dimmedView.alpha = 0.6
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.output.closeForgetPasswordScreen()
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
    private func raiseViewWithKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    private func dropDownViewWithoutKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
extension ForgetPasswordScreenViewController: AuthStackViewDelegate {
    func endEditingTextField(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
extension ForgetPasswordScreenViewController: AuthStackViewDataSource {
    func addDoneButton(for tag: Int) -> UIView {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.isHidden = true
        return keyboardToolbar
    }
    
    
    
    func setupKeyboardType(for tag: Int) -> UIKeyboardType {
        return UIKeyboardType.default
    }
    
    
    func isSecurityEntryOn(for tag: Int) -> Bool {
        return false
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
        var returnPlaceholder: String
        switch tag {
        case 0,2:
            returnPlaceholder = Placeholders.email.rawValue
        case 1:
            returnPlaceholder = Placeholders.password.rawValue
        default:
            returnPlaceholder = ""
        }
        return returnPlaceholder
    }
}
