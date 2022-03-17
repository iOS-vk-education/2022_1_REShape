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
    let signUpButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(reShapeImage)
        view.addSubview(additionalText)
        view.addSubview(enterButton)
        view.addSubview(signUpLabel)
        view.addSubview(signUpButton)
        
        // Configure additional text
        additionalText.text = "Добро пожаловать в приложение, помогающее прийти в форму 💪"
        additionalText.font = UIFont(descriptor: UIFontDescriptor(), size: 22)
        additionalText.numberOfLines = 3
        
        // Configure enter button
        enterButton.setTitle("Войти", for: .normal)
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.backgroundColor = UIColor(red: 0.365,
                                              green: 0.302,
                                              blue: 0.745,
                                              alpha: 1)
        enterButton.layer.cornerRadius = 16
        enterButton.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(), size: 24)
        enterButton.addTarget(self, action: #selector(enterTap), for: .touchUpInside)
        
        // Configure description text to sign up
        signUpLabel.text = "Если у вас нет аккаунта, то нажмите"
        signUpLabel.font = UIFont(descriptor: UIFontDescriptor(), size: 14)
        signUpLabel.textColor = UIColor(red: 0.78,
                                        green: 0.78,
                                        blue: 0.8,
                                        alpha: 1)
        signUpLabel.numberOfLines = 1
        signUpLabel.textAlignment = .center
        
        // Configure sign up button
        signUpButton.setTitle("зарегистрироваться", for: .normal)
        signUpButton.setTitleColor(UIColor(red: 0.365,
                                           green: 0.302,
                                           blue: 0.745,
                                           alpha: 1), for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        signUpButton.titleLabel?.numberOfLines = 1
        signUpButton.titleLabel?.textAlignment = .center
        signUpButton.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        signUpButton.addTarget(self, action: #selector(signUpTap), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // REShape name PinLayout
        reShapeImage.pin
            .top(view.safeAreaInsets.top + 60)
            .hCenter()
            .width(231)
            .sizeToFit(.height)
        
        // Addtional text PinLayout
        additionalText.pin
            .top(view.safeAreaInsets.top + 498)
            .hCenter()
            .width(281)
            .height(78)
        
        // Enter button PinLayout
        enterButton.pin
            .below(of: additionalText)
            .marginTop(30)
            .hCenter()
            .width(306)
            .height(55)
        
        // Description text PinLayout
        signUpLabel.pin
            .below(of: enterButton)
            .marginTop(13)
            .left(65)
            .right(65)
            .sizeToFit(.width)
            .height(14)
        
        // Sign up button PinLayout
        signUpButton.pin
            .below(of: signUpLabel)
            .marginTop(0)
            .left(65)
            .right(65)
            .sizeToFit(.width)
            .height(14)
    }
    
    @objc
    private func enterTap() {
        
    }
    
    @objc
    private func signUpTap() {
        
    }
}
