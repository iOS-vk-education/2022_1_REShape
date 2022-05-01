//
//  CustomView.swift
//  reshape
//
//  Created by Полина Константинова on 30.03.2022.
//

import Foundation
import UIKit

protocol CustomProfileDelegate: AnyObject {
    func quitButtonAction()
}

final class CustomProfileView: UIView {
    weak var delegate: CustomProfileDelegate?
    
    private let progressBar: CircularProgressBarView = CircularProgressBarView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
    
    private let backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "Gradient")
        backgroundImage.layer.cornerRadius = 40
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        backgroundImage.layer.masksToBounds = true
        backgroundImage.layer.shadowOffset = CGSize(width: 4, height: 4)
        backgroundImage.layer.shadowColor = CGColor(red: 20, green: 4, blue: 65, alpha: 0.2)
        return backgroundImage
    }()
    
    let quitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "quitButton"),for: .normal)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Ника Рябова"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        return nameLabel
    }()
    
    private let phoneNumberLabel: UILabel = {
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.text = "+7(123)-456-78-90"
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        phoneNumberLabel.textColor = .white
        return phoneNumberLabel
    }()
    
    private let personalStackView: UIStackView = {
        let personalStackView = UIStackView()
        personalStackView.translatesAutoresizingMaskIntoConstraints = false
        personalStackView.axis = .vertical
        personalStackView.spacing = 3
        return personalStackView
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

    private func setupConstraints(){
        self.addSubview(backgroundImage)
        backgroundImage.top(isIncludeSafeArea: false)
        backgroundImage.leading()
        backgroundImage.trailing()
        backgroundImage.bottom(isIncludeSafeArea: false)
        
        self.addSubview(progressBar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.center = self.center
        progressBar.centerX()
        progressBar.centerY()
        progressBar.height(130)
        progressBar.width(130)
        
        self.addSubview(personalStackView)
        personalStackView.centerX()
        NSLayoutConstraint.activate([
            personalStackView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 33)
        ])
        personalStackView.addArrangedSubview(nameLabel)
        personalStackView.addArrangedSubview(phoneNumberLabel)
        nameLabel.leading()
        nameLabel.trailing()
        phoneNumberLabel.leading()
        phoneNumberLabel.trailing()
        
        self.addSubview(quitButton)
        NSLayoutConstraint.activate([
            quitButton.topAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: 65)
        ])
        quitButton.trailing(-30)
    }
    
    func setupUI(){
        progressBar.progressColor = UIColor.blueColor ?? .white
        progressBar.circleColor = UIColor.blueColor?.withAlphaComponent(0) ?? .systemGray
        progressBar.tag = 101
        
        quitButton.isUserInteractionEnabled = true
        quitButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
    }
    @objc func quitButtonTapped(){
        delegate?.quitButtonAction()
    }
}
    
