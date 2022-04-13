//
//  CustomView.swift
//  reshape
//
//  Created by Полина Константинова on 30.03.2022.
//

import Foundation
import UIKit

final class CustomWaterView: UIView {
    private let waterImage: UIImageView = {
        let waterImage = UIImageView()
        waterImage.image = UIImage(named: "Gradient")
        waterImage.layer.cornerRadius = 40
        waterImage.translatesAutoresizingMaskIntoConstraints = false
        waterImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        waterImage.layer.masksToBounds = true
        return waterImage
        //
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
    private let percentStackView: UIStackView = {
        let percentStackView = UIStackView()
        percentStackView.translatesAutoresizingMaskIntoConstraints = false
        percentStackView.axis = .vertical
        percentStackView.spacing = 4
        return percentStackView
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
        waterImage.top(isIncludeSafeArea: false)
        waterImage.leading()
        waterImage.trailing()
        waterImage.bottom(isIncludeSafeArea: false)
        
        self.addSubview(percentLabel)
        
        percentLabel.centerX()
        percentLabel.centerY()
        percentLabel.height(percentLabel.bounds.height)
        percentLabel.width(percentLabel.bounds.width)
        self.addSubview(percentStackView)
        percentStackView.centerX()
        NSLayoutConstraint.activate([
            percentStackView.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 33)
        ])
    }
}
    
