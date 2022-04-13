//
//  RegistrationContentView.swift
//  reshape
//
//  Created by Veronika on 13.04.2022.
//

import Foundation
import UIKit

protocol RegistrationContentViewDelegate: AnyObject {
    func endEditingTextField(_ textField: UITextField) -> Bool
}
protocol RegistrationContentViewDataSource: AnyObject {}



final class RegistrationContentView: UIView {
    
    weak var delegate: RegistrationContentViewDelegate?
    weak var dataSource: AuthStackViewDataSource? {
        didSet {
            for stack in stackViews{
                stack.dataSource = dataSource
            }
        }
    }
    private let genderStackView: GenderStackView = {
        let stackView = GenderStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.tag = 0
        return stackView
    }()
    
    private lazy var stackViews: [AuthStackView] = {
        var stackViews = [AuthStackView]()
        for value in 0..<8 {
            let stack = AuthStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.backgroundTFColor = .modalViewGrayColor ?? .gray
            stack.tag = value + 1
            stackViews.append(stack)
        }
        return stackViews
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
        
        if let firstView = stackViews.first, stackViews.count > 1 {
            self.addSubview(firstView)
            NSLayoutConstraint.activate([
                firstView.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 11)
            ])
            firstView.leading()
            firstView.trailing()
            firstView.height(69)
            
            for value in 1..<8{
                self.addSubview(stackViews[value])
                stackViews[value].leading()
                stackViews[value].trailing()
                stackViews[value].height(69)
                NSLayoutConstraint.activate([
                    stackViews[value].topAnchor.constraint(equalTo: stackViews[value - 1].bottomAnchor, constant: 11)
                ])
            }
        } else {
            self.addSubview(stackViews[0])
            NSLayoutConstraint.activate([
                stackViews[0].topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 15)
            ])
            stackViews[0].leading()
            stackViews[0].trailing()
            stackViews[0].height(69)
        }

        self.addSubview(registrationButton)
        guard let lastView = stackViews.last else {
            return
        }
        NSLayoutConstraint.activate([
            registrationButton.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 11)
        ])
        registrationButton.leading()
        registrationButton.trailing()
        registrationButton.height(55)
        registrationButton.bottom(isIncludeSafeArea: false)
    }
    func setupUI(){
        
        registrationButton.setupUI(name: "Зарегестрироваться")

    }
}


extension RegistrationContentView: AuthStackViewDelegate {
    func endEditingTextField(_ textField: UITextField) -> Bool {
        guard let delegate = delegate else { return false }
        return delegate.endEditingTextField(textField)
    }
}
