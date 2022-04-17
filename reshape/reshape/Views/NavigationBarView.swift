//
//  TitleView.swift
//  reshape
//
//  Created by Veronika on 04.04.2022.
//

import Foundation
import UIKit

protocol NavigationBarDelegate: AnyObject {
    func backButtonAction()
}

final class NavigationBarView: UIView {
    weak var delegate: NavigationBarDelegate?
    let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Регистрация"
        label.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        label.textColor = UIColor.violetColor
        label.textAlignment = .center
        return label
    }()

    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "back"),for: .normal)
        return button
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
extension NavigationBarView {
    func setupConstraints() {
        self.addSubview(mainLabel)
        self.addSubview(backButton)
        
        mainLabel.top(40, isIncludeSafeArea: false)
        mainLabel.centerX()
        
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor)
        ])
        backButton.leading(17)
        
    }
    func setupUI() {
        backButton.isUserInteractionEnabled = true
        backButton.addTarget(self, action:#selector(backButtonTapped), for: .touchUpInside)
    }
    @objc
    func backButtonTapped(){
        delegate?.backButtonAction()
    }
}

extension NavigationBarView {
    func setConfigForWeightScreen(withName name: String) {
        setupConstraintsForWeightScreen()
        setupUIForWeightScreen(setName: name)
    }
    
    private func setupConstraintsForWeightScreen() {
        NSLayoutConstraint.deactivate(self.constraints)
        backButton.height(27)
        backButton.width(76)
        backButton.leading(17)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.topAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            mainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func setupUIForWeightScreen(setName name: String) {
        backButton.contentHorizontalAlignment = .leading
        self.mainLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.mainLabel.textColor = .white
        self.mainLabel.attributedText = NSAttributedString(string: name, attributes: [ NSAttributedString.Key.kern: 0.77])
    }
}

