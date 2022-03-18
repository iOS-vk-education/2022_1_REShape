//
//  EnterScreen.swift
//  reshape
//
//  Created by Иван Фомин on 17.03.2022.
//

import Foundation
import UIKit
import PinLayout

final class EnterScreen: UIViewController {
    // REShape name on top screen
    let reShapeImage: UIImageView = UIImageView(image: UIImage(named: "GreenVioletName"))
    
    // Welcome text above enter button
    let additionalText: UILabel = UILabel()
    
    // Enter button
    let enterButton: UIButton = UIButton()
    
    // Description text to sign up
    let signUpLabel: UILabel = UILabel()
    
    // Sign up button (string)
    let signUpButton: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(reShapeImage)
        view.addSubview(additionalText)
        view.addSubview(enterButton)
        view.addSubview(signUpLabel)
        view.addSubview(signUpButton)
        
        // Configure additional text
        additionalText.text = "Добро пожаловать в приложение, помогающее прийти в форму 💪"
        additionalText.font = UIFont.systemFont(ofSize: 22)
        additionalText.numberOfLines = 0
        
        // Configure enter button
        enterButton.setTitle("Войти", for: .normal)
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.backgroundColor = UIColor(red: 0.365,
                                              green: 0.302,
                                              blue: 0.745,
                                              alpha: 1)
        enterButton.layer.cornerRadius = 16
        enterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        enterButton.addTarget(self, action: #selector(enterTouchUp), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(enterTouchDown), for: .touchDown)
        
        // Configure description text to sign up
        signUpLabel.text = "Если у вас нет аккаунта, то нажмите"
        signUpLabel.font = UIFont.systemFont(ofSize: 14)
        signUpLabel.textColor = UIColor(red: 0.78,
                                        green: 0.78,
                                        blue: 0.8,
                                        alpha: 1)
        signUpLabel.numberOfLines = 1
        signUpLabel.textAlignment = .center
        
        // Configure sign up button
        signUpButton.attributedText = NSAttributedString(string: "зарегистироваться", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        signUpButton.textColor = UIColor(red: 0.365,
                                          green: 0.302,
                                          blue: 0.745,
                                          alpha: 1)
        signUpButton.font = UIFont.systemFont(ofSize: 14)
        signUpButton.numberOfLines = 1
        signUpButton.textAlignment = .center
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
        
        // Enter button PinLayout
        enterButton.pin
            .top(view.safeAreaInsets.top + 606)
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
        
        // Description text PinLayout
        signUpLabel.pin
            .below(of: enterButton)
            .marginTop(13)
            .left(65)
            .right(65)
            .sizeToFit(.width)
            .height(17)
        
        // Sign up button PinLayout
        signUpButton.pin
            .below(of: signUpLabel)
            .marginTop(0)
            .left(65)
            .right(65)
            .sizeToFit(.width)
            .height(17)
    }
    
    @objc
    private func enterTouchUp() {
        enterButton.alpha = 1
        print("[DEBUG] Enter button")
    }
    
    @objc
    private func enterTouchDown() {
        enterButton.alpha = 0.5
    }
    
    @objc
    private func signUpTap() {
        print("[DEBUG] Sign Up button")
    }
}
