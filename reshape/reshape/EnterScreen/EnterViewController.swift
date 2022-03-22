//
//  EnterViewController.swift
//  reshape
//
//  Created by Иван Фомин on 18.03.2022.
//  
//

import UIKit

final class EnterViewController: UIViewController {
    // REShape name on top screen
    private let reShapeImage: UIImageView = UIImageView(image: UIImage(named: "GreenVioletName"))
    
    // Enter button
    private let enterButton: EnterButton = EnterButton()
    
    // Welcome text above enter button
    private let additionalText: UILabel = {
        let label = UILabel()
        label.text = "Добро пожаловать в приложение, помогающее прийти в форму 💪"
        label.font = UIFont.systemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()
    
    // Description text to sign up
    private let signUpLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Если у вас нет аккаунта, то нажмите"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "Light Gray")
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    // Sign up button (string)
    private let signUpButton: UILabel = {
        let label: UILabel = UILabel()
        label.attributedText = NSAttributedString(string: "зарегистироваться", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.textColor = UIColor(named: "Violet")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let output: EnterViewOutput
    
    init(output: EnterViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(reShapeImage)
        view.addSubview(additionalText)
        view.addSubview(enterButton)
        view.addSubview(signUpLabel)
        view.addSubview(signUpButton)
        
        enterButton.setupUI(name: "Войти")
        
        reShapeImage.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        additionalText.translatesAutoresizingMaskIntoConstraints = false
        
        // ReShape logo Constraints
        reShapeImage.top(60, isIncludeSafeArea: true)
        reShapeImage.centerX()
        reShapeImage.width(231)
        
        // Sign up button Constraints
        signUpButton.bottom(-26, isIncludeSafeArea: true)
        signUpButton.centerX()
        signUpButton.height(17)
        
        // Description text Constraints
        signUpLabel.centerX()
        signUpLabel.height(17)
        
        // Enter button constraints
        enterButton.centerX()
        enterButton.height(55)
        enterButton.width(306)
        
        // Additional text constraints
        additionalText.centerX()
        additionalText.width(281)
        
        NSLayoutConstraint.activate([
            reShapeImage.heightAnchor.constraint(lessThanOrEqualToConstant: 72),
            signUpLabel.bottomAnchor.constraint(equalTo: signUpButton.topAnchor),
            enterButton.bottomAnchor.constraint(equalTo: signUpLabel.topAnchor, constant: -13),
            additionalText.bottomAnchor.constraint(equalTo: enterButton.topAnchor, constant: -30),
            additionalText.heightAnchor.constraint(greaterThanOrEqualToConstant: 78),
        ])
        
        enterButton.action = {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.enterButton.backgroundColor = UIColor(named: "Violet Pressed")
            } completion: { [weak self] finished in
                if finished {
                    self?.output.showLoginScreen()
                    self?.enterButton.backgroundColor = UIColor(named: "Violet")
                }
            }
        }
        enterButton.isUserInteractionEnabled = true
        signUpButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpTap)))
    }
    
    @objc
    private func signUpTap() {
        print("[DEBUG] Sign Up button")
    }
}

extension EnterViewController: EnterViewInput {
}
