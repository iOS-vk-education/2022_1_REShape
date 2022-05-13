//
//  CustomView.swift
//  reshape
//
//  Created by Полина Константинова on 30.03.2022.
//

import Foundation
import UIKit

protocol CustomWaterDelegate: AnyObject {
    func backButtonAction()
}

final class CustomWaterView: UIView {
    
    weak var delegate: CustomWaterDelegate?
    
    private let waterImage: UIImageView = {
        let waterImage = UIImageView()
        waterImage.image = UIImage(named: "WaterGradient")
        waterImage.layer.cornerRadius = 40
        waterImage.translatesAutoresizingMaskIntoConstraints = false
        waterImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        waterImage.layer.masksToBounds = true
        return waterImage
    }()
    
    private let percentLabel: UILabel = {
        let percentLabel = UILabel()
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.text = "65%"
        percentLabel.font = UIFont.systemFont(ofSize: 40, weight: .regular)
        percentLabel.textAlignment = .center
        percentLabel.textColor = .white
        return percentLabel
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "waterBackButton"),for: .normal)
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupUI()

    }
    
    func changeState() {
        self.layoutIfNeeded()
        waterImage.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupConstraints()
        setupUI()

    }
    
    func setupConstraints(){
        self.addSubview(waterImage)
        waterImage.top(60, isIncludeSafeArea: false)
        waterImage.leading()
        waterImage.trailing()
        waterImage.bottom(isIncludeSafeArea: false)
        
        self.addSubview(percentLabel)
        percentLabel.centerX()
        NSLayoutConstraint.activate([percentLabel.topAnchor.constraint(equalTo: waterImage.topAnchor, constant: 45)])
        percentLabel.height(30)
        percentLabel.width(100)
        
        self.addSubview(backButton)
        backButton.height(27)
        backButton.width(76)
        backButton.leading(11)
        backButton.top(3, isIncludeSafeArea: false)
    }
    
    func setupUI(){
        backButton.isUserInteractionEnabled = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped(){
        delegate?.backButtonAction()
    }
}
