//
//  LoginView.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//

import Foundation
import UIKit

protocol AuthStackViewDelegate: AnyObject {
    func endEditingTextField(_ textField: UITextField) -> Bool
}

protocol AuthStackViewDataSource: AnyObject {
    func labelText(tag: Int) -> String
    func placeholderText(tag: Int) -> String
    func isSecurityEntryOn(for tag: Int) -> Bool
    func setupKeyboardType(for tag: Int) -> UIKeyboardType
    func addDoneButton(for tag: Int) ->  UIView
}

final class AuthStackView: UIView {
    
    weak var delegate: AuthStackViewDelegate?
    weak var dataSource: AuthStackViewDataSource?{
        didSet {
            label.text = dataSource?.labelText(tag: tag)
            textField.placeholder = dataSource?.placeholderText(tag: tag)
            textField.isSecureTextEntry = dataSource?.isSecurityEntryOn(for: tag) ?? false
            textField.keyboardType = dataSource?.setupKeyboardType(for: tag) ?? UIKeyboardType.default
            textField.inputAccessoryView = dataSource?.addDoneButton(for: tag)
        }
    }

    var backgroundTFColor: UIColor = UIColor.green {
        didSet {
            textField.backgroundColor = backgroundTFColor
        }
    }
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private(set) lazy var textField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.textColor = .black
        textField.backgroundColor = backgroundTFColor
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpConstraint()
    }
    
    
    private func setUpConstraint(){
        textField.delegate = self
        self.addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textField)
        stackView.top(isIncludeSafeArea: false)
        
        stackView.leading()
        stackView.trailing()
        
        label.leading(4)
        label.height(19)
        
        textField.leading()
        textField.trailing()
        textField.height(42)
        
    }
}

extension AuthStackView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let delegate = delegate else { return false }
        return delegate.endEditingTextField(textField)
    }
}

