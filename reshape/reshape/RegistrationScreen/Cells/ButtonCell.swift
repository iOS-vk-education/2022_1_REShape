//
//  ButtonCell.swift
//  reshape
//
//  Created by Veronika on 08.04.2022.
//

import Foundation
import UIKit

final class ButtonCell: UITableViewCell {
    let registerButton: EnterButton = EnterButton()
    var action: (() -> Void)?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
        setupUI()
    }
}
extension ButtonCell{
    func setupConstraints(){
        self.contentView.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.height(55)
        registerButton.leading()
        registerButton.trailing()
        registerButton.top(14, isIncludeSafeArea: false)
    }
    func setupUI(){
        registerButton.setupUI(name: "Зарегестрироваться")
        registerButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    @objc
    func buttonTapped(){
        action?()
    }
}
