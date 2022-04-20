//
//  WeightCell.swift
//  reshape
//
//  Created by Иван Фомин on 17.04.2022.
//

import UIKit

final class WeightCell: AbstractCell {
    weak var view: WeightViewInput?
    
    private let rightTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        text.textColor = UIColor.darkVioletColor
        text.text = ""
        text.textAlignment = .right
        text.keyboardType = .decimalPad
        return text
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.addSubview(rightTextField)
        rightTextField.delegate = self
    }
    
    private func setupConstraints() {
        rightTextField.width(100)
        NSLayoutConstraint.activate([
            rightTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            rightTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rightTextField.text = "0"
    }
}

extension WeightCell {
    func setData(stringForCell cellText: String, stringForData dataText: Int) {
        self.setCellText(cellText)
        self.setData(stringForData: dataText)
    }
    
    func setData(stringForData dataText: Int) {
        rightTextField.text = "\(dataText)"
    }
    
    func tapped() {
        rightTextField.becomeFirstResponder()
    }
    
    func unchosen() {
        rightTextField.endEditing(false)
    }
}

extension WeightCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        view?.startEditing()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let weight = Int(rightTextField.text!) else {
            view?.cancelEditing()
            return
        }
        view?.endEditing(withWeight: weight)
    }
}
