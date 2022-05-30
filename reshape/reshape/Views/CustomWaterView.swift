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
    func customWaterGetTotal() -> Int
    func customWaterGetWeight() -> Double
}

final class CustomWaterView: UIView {
    
    weak var delegate: CustomWaterDelegate?
    
    private let waterImage: UIImageView = {
        let waterImage = UIImageView()
        waterImage.image = UIImage(named: "WaterGradient")
        waterImage.contentMode = .scaleToFill
        return waterImage
    }()
    
    private let percentLabel: UILabel = {
        let percentLabel = UILabel()
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.text = "0%"
        percentLabel.font = UIFont.systemFont(ofSize: 40, weight: .regular)
        percentLabel.textAlignment = .center
        percentLabel.textColor = .white
        return percentLabel
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "WaterBackButton"),for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupUI()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        // Проверка на первый запуск
        if waterImage.frame == .zero {
            let newFrameY = self.frame.height * 0.75
            let newFrameHeight = self.frame.height * 0.25 - 5
            waterImage.frame.origin = CGPoint(x: 0, y: newFrameY)
            waterImage.frame.size = CGSize(width: self.frame.width, height: newFrameHeight)
        }
        changeState()
    }
    
    func changeState() {
        let total = delegate?.customWaterGetTotal() ?? 0
        guard let weight = delegate?.customWaterGetWeight(), weight != -1 else {
            return
        }
        var percent = Double(total) / (weight * 30)
        if percent < 0.5 {
            percentLabel.textColor = .black
        } else {
            percentLabel.textColor = .white
        }
        percentLabel.text = "\(Int(percent * 100))%"
        
        // Craete mask
        if percent > 1 {
            percent = 1
            waterImage.image = UIImage(named: "WaterMaxGradient")
            backButton.setImage(UIImage(named: "WaterMaxBackButton"),for: .normal)
        } else if percent < 0 {
            percent = 0
            waterImage.image = UIImage(named: "WaterGradient")
            backButton.setImage(UIImage(named: "WaterBackButton"),for: .normal)
        } else {
            waterImage.image = UIImage(named: "WaterGradient")
            backButton.setImage(UIImage(named: "WaterBackButton"),for: .normal)
        }
        let imagePercent = 0.7 * percent + 0.25
        let frameY = self.frame.height * (1-imagePercent)
        let frameHeight = self.frame.height * imagePercent - 5
        let animator = UIViewPropertyAnimator(duration: 2, curve: .easeOut, animations: {
            self.waterImage.frame = CGRect(x: 0, y: frameY, width: self.frame.width, height: frameHeight)
        })
        animator.startAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupConstraints()
        setupUI()
    }
    
    private func setupConstraints(){
        self.addSubview(waterImage)
        waterImage.frame = CGRect(x: 0, y: self.frame.height * 0.9, width: self.frame.width, height: self.frame.height)
        
        self.addSubview(percentLabel)
        NSLayoutConstraint.activate([
            percentLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            percentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10)
        ])
        percentLabel.centerX()
        percentLabel.height(30)
        
        
        self.addSubview(backButton)
        backButton.height(27)
        backButton.width(76)
        backButton.leading(17)
        backButton.top(isIncludeSafeArea: false)
    }
    
    private func setupUI(){
        backButton.isUserInteractionEnabled = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Layer
        waterImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        waterImage.layer.masksToBounds = true
        waterImage.layer.cornerRadius = 40
    }

    @objc func backButtonTapped(){
        delegate?.backButtonAction()
    }
}
