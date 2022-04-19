//
//  CustomView.swift
//  reshape
//
//  Created by Полина Константинова on 30.03.2022.
//

import Foundation
import UIKit

protocol CustomWaterViewDelegate: AnyObject {
    func waterBackButtonAct()
}

final class CustomWaterView: UIView {
    weak var delegate: CustomWaterViewDelegate?
    private let waterImage: UIImageView = {
        let waterImage = UIImageView()
        waterImage.image = UIImage(named: "WaterGradient")
        waterImage.layer.cornerRadius = 40
        waterImage.translatesAutoresizingMaskIntoConstraints = false
        waterImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        waterImage.layer.masksToBounds = true
        return waterImage
    }()
    
    let waterBackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "waterBackButton"),for: .normal)
        return button
    }()
    
    private let percentLabel: UILabel = {
        let percentLabel = UILabel()
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.text = "65%"
        percentLabel.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        percentLabel.textAlignment = .center
        percentLabel.textColor = .white
        return percentLabel
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupConstraints()

    }
   
    private func setupConstraints(){
        self.addSubview(waterImage)
        waterImage.top(60, isIncludeSafeArea: false)
        waterImage.leading()
        waterImage.trailing()
        waterImage.bottom(isIncludeSafeArea: false)
        
        self.addSubview(waterBackButton)
        NSLayoutConstraint.activate([waterBackButton.bottomAnchor.constraint(equalTo: waterImage.topAnchor, constant: 10)])
        waterBackButton.leading(17)
        
        self.addSubview(percentLabel)
        percentLabel.centerX()
        NSLayoutConstraint.activate([percentLabel.topAnchor.constraint(equalTo: waterImage.topAnchor, constant: 117)])
        percentLabel.height(30)
        percentLabel.width(100)
    }
}
    
