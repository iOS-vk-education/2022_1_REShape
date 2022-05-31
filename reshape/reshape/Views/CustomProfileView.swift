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

final class CustomProfileView: UpGradientPanel {
    weak var delegate: CustomProfileDelegate?
    
    private let progressBar: CircularProgressBarView = CircularProgressBarView(frame: CGRect(x: 0, y: 0, width: 131, height: 131))
    
    let quitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "quitButton"),for: .normal)
        return button
    }()
    
    private(set) var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Имя пользователя"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        return nameLabel
    }()
    
    private(set) var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = "почта"
        emailLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        emailLabel.textColor = .white
        return emailLabel
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
        self.addSubview(progressBar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.center = self.center
        progressBar.centerX()
        progressBar.top(79, isIncludeSafeArea: false)
        progressBar.height(131)
        progressBar.width(131)
        
        self.addSubview(personalStackView)
        personalStackView.centerX()
        NSLayoutConstraint.activate([
            personalStackView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 33)
        ])
        personalStackView.addArrangedSubview(nameLabel)
        personalStackView.addArrangedSubview(emailLabel)
        nameLabel.leading()
        nameLabel.trailing()
        emailLabel.leading()
        emailLabel.trailing()
        
        self.addSubview(quitButton)
        quitButton.top(40, isIncludeSafeArea: false)
        quitButton.trailing(-27)
    }
    
    func setupUI(){
        progressBar.progressColor = UIColor.blueColor
        progressBar.circleColor = UIColor.blueColor.withAlphaComponent(0)
        progressBar.tag = 101
        
        quitButton.isUserInteractionEnabled = true
        quitButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
    }
    
    @objc func quitButtonTapped(){
        delegate?.quitButtonAction()
    }
}

//extension CustomProfileView {
//    func setConfigForProfileScreen(withName name: String, withEmail email: String){
//        setNameForProfileScreen(setName: name)
//        setEmailForProfileScreen(setEmail: email)
//    }
//
//    func setNameForProfileScreen(setName name: String) {
//        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        self.nameLabel.textColor = .white
//        self.nameLabel.text = name
//    }
//
//    func setEmailForProfileScreen(setEmail email: String){
//        emailLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        self.emailLabel.textColor = .white
//        self.emailLabel.text = email
//    }
//}
    
