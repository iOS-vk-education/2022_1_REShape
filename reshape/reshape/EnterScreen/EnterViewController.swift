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
        
        // ReShape logo Constraints
        reShapeImage.translatesAutoresizingMaskIntoConstraints = false
        reShapeImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        reShapeImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        reShapeImage.widthAnchor.constraint(equalToConstant: 231).isActive = true
        reShapeImage.heightAnchor.constraint(lessThanOrEqualToConstant: 72).isActive = true
        
        // Sign up button Constraints
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -26).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        // Description text Constraints
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.bottomAnchor.constraint(equalTo: signUpButton.topAnchor).isActive = true
        signUpLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        signUpLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        // Enter button constraints
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.bottomAnchor.constraint(equalTo: signUpLabel.topAnchor, constant: -13).isActive = true
        enterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        enterButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        enterButton.widthAnchor.constraint(equalToConstant: 306).isActive = true
        
        // Additional text constraints
        additionalText.translatesAutoresizingMaskIntoConstraints = false
        additionalText.bottomAnchor.constraint(equalTo: enterButton.topAnchor, constant: -30).isActive = true
        additionalText.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        additionalText.heightAnchor.constraint(greaterThanOrEqualToConstant: 78).isActive = true
        additionalText.widthAnchor.constraint(equalToConstant: 281).isActive = true
        
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
