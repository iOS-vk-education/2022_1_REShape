//
//  RegistrationContentView.swift
//  reshape
//
//  Created by Veronika on 13.04.2022.
//

import Foundation
import UIKit

final class RegistrationContentView: UIView {
    
    private let genderStackView: GenderStackView = {
        let stackView = GenderStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.tag = 0
        return stackView
    }()
    
    private let nameStackView: AuthStackView = {
        let nameStackView = AuthStackView()
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.tag = 1
        return nameStackView
    }()
    private let surnameStackView: AuthStackView = {
        let nameStackView = AuthStackView()
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.tag = 2
        return nameStackView
    }()
    
    private let ageStackView: AuthStackView = {
        let ageStackView = AuthStackView()
        ageStackView.translatesAutoresizingMaskIntoConstraints = false
        ageStackView.tag = 3
        return ageStackView
    }()
    
    private let heightStackView: AuthStackView = {
        let heightStackView = AuthStackView()
        heightStackView.translatesAutoresizingMaskIntoConstraints = false
        heightStackView.tag = 4
        return heightStackView
    }()
    
    private let weightStackView: AuthStackView = {
        let weightStackView = AuthStackView()
        weightStackView.translatesAutoresizingMaskIntoConstraints = false
        weightStackView.tag = 5
        return weightStackView
    }()
    
    private let targetStackView: AuthStackView = {
        let targetStackView = AuthStackView()
        targetStackView.translatesAutoresizingMaskIntoConstraints = false
        targetStackView.tag = 6
        return targetStackView
    }()
    
    private let emailStackView: AuthStackView = {
        let emailStackView = AuthStackView()
        emailStackView.translatesAutoresizingMaskIntoConstraints = false
        emailStackView.tag = 7
        return emailStackView
    }()
    
    private let passwordStackView: AuthStackView = {
        let passwordStackView = AuthStackView()
        passwordStackView.translatesAutoresizingMaskIntoConstraints = false
        passwordStackView.tag = 8
        return passwordStackView
    }()
    
    private let registrationButton: EnterButton = {
        let registrationButton = EnterButton()
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        registrationButton.tag = 9
        return registrationButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupConstraints()
        setupUI()
    }
}

extension RegistrationContentView {
    func setupConstraints(){
        self.addSubview(genderStackView)
        genderStackView.top(isIncludeSafeArea: false)
        genderStackView.leading()
        genderStackView.trailing()
        genderStackView.height(69)
        
        self.addSubview(nameStackView)
        NSLayoutConstraint.activate([
            nameStackView.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 11)
        ])
        nameStackView.leading()
        nameStackView.trailing()
        nameStackView.height(69)

        self.addSubview(surnameStackView)
        NSLayoutConstraint.activate([
            surnameStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: 11)
        ])
        surnameStackView.leading()
        surnameStackView.trailing()
        surnameStackView.height(69)
        
        self.addSubview(ageStackView)
        NSLayoutConstraint.activate([
            ageStackView.topAnchor.constraint(equalTo: surnameStackView.bottomAnchor, constant: 11)
        ])
        ageStackView.leading()
        ageStackView.trailing()
        ageStackView.height(69)
        
        self.addSubview(heightStackView)
        NSLayoutConstraint.activate([
            heightStackView.topAnchor.constraint(equalTo: ageStackView.bottomAnchor, constant: 11)
        ])
        heightStackView.leading()
        heightStackView.trailing()
        heightStackView.height(69)
        
        self.addSubview(weightStackView)
        NSLayoutConstraint.activate([
            weightStackView.topAnchor.constraint(equalTo: heightStackView.bottomAnchor, constant: 11)
        ])
        weightStackView.leading()
        weightStackView.trailing()
        weightStackView.height(69)
        
        self.addSubview(targetStackView)
        NSLayoutConstraint.activate([
            targetStackView.topAnchor.constraint(equalTo: weightStackView.bottomAnchor, constant: 11)
        ])
        targetStackView.leading()
        targetStackView.trailing()
        targetStackView.height(69)
        
        self.addSubview(emailStackView)
        NSLayoutConstraint.activate([
            emailStackView.topAnchor.constraint(equalTo: targetStackView.bottomAnchor, constant: 11)
        ])
        emailStackView.leading()
        emailStackView.trailing()
        emailStackView.height(69)
        
        self.addSubview(passwordStackView)
        NSLayoutConstraint.activate([
            passwordStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 11)
        ])
        passwordStackView.leading()
        passwordStackView.trailing()
        passwordStackView.height(69)
        
        self.addSubview(registrationButton)
        NSLayoutConstraint.activate([
            registrationButton.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: 11)
        ])
        registrationButton.leading()
        registrationButton.trailing()
        registrationButton.height(55)
        registrationButton.bottom(isIncludeSafeArea: false)
    }
    func setupUI(){
//        nameStackView.delegate = self
//        nameStackView.dataSource = self
        nameStackView.backgroundTFColor = .modalViewGrayColor ?? .gray
        
//        surnameStackView.delegate = self
//        surnameStackView.dataSource = self
        surnameStackView.backgroundTFColor = .modalViewGrayColor ?? .gray
        
        ageStackView.backgroundTFColor = .modalViewGrayColor ?? .gray
        
        heightStackView.backgroundTFColor = .modalViewGrayColor ?? .gray
        
        weightStackView.backgroundTFColor = .modalViewGrayColor ?? .gray
        
        targetStackView.backgroundTFColor = .modalViewGrayColor ?? .gray

        emailStackView.backgroundTFColor = .modalViewGrayColor ?? .gray
        
        passwordStackView.backgroundTFColor = .modalViewGrayColor ?? .gray
        
        registrationButton.setupUI(name: "Зарегестрироваться")

    }
}
