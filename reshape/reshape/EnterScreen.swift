//
//  EnterScreen.swift
//  reshape
//
//  Created by Иван Фомин on 17.03.2022.
//

import Foundation
import UIKit
import PinLayout

final class EnterButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setTitle("Войти", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor(named: "Violet")
        self.layer.cornerRadius = 16
        self.titleLabel?.font = UIFont.systemFont(ofSize: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class EnterScreen: UIViewController {
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
    let signUpButton: UILabel = {
        let label: UILabel = UILabel()
        label.attributedText = NSAttributedString(string: "зарегистироваться", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.textColor = UIColor(named: "Violet")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSubview()
    }
    
    func viewSubview() {
        view.backgroundColor = .white
        view.addSubview(reShapeImage)
        view.addSubview(additionalText)
        view.addSubview(enterButton)
        view.addSubview(signUpLabel)
        view.addSubview(signUpButton)
        
        enterButton.addTarget(self, action: #selector(enterTouchUp), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(enterTouchDown), for: .touchDown)
        
        signUpButton.isUserInteractionEnabled = true
        signUpButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpTap)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // REShape name PinLayout
        reShapeImage.pin
            .top(view.safeAreaInsets.top + 60)
            .hCenter()
            .width(231)
            .sizeToFit(.height)
        
        // Sign up button PinLayout
        signUpButton.pin
            .bottom(view.safeAreaInsets.bottom + 26)
            .left(65)
            .right(65)
            .sizeToFit(.width)
            .height(17)
        
        // Description text PinLayout
        signUpLabel.pin
            .above(of: signUpButton)
            .marginBottom(0)
            .left(20)
            .right(20)
            .sizeToFit(.width)
            .height(17)
        
        // Enter button PinLayout
        enterButton.pin
            .above(of: signUpLabel)
            .marginBottom(13)
            .hCenter()
            .width(306)
            .height(55)
        
        // Additional text PinLayout
        additionalText.pin
            .above(of: enterButton)
            .marginBottom(30)
            .hCenter()
            .width(281)
            .minHeight(78)
            .sizeToFit(.width)
    }
    
    @objc
    private func enterTouchUp() {
        enterButton.backgroundColor = UIColor(named: "Violet")
        print("[DEBUG] Enter button")
    }
    
    @objc
    private func enterTouchDown() {
        enterButton.backgroundColor = UIColor(named: "Violet Pressed")
    }
    
    @objc
    private func signUpTap() {
        print("[DEBUG] Sign Up button")
    }
}
