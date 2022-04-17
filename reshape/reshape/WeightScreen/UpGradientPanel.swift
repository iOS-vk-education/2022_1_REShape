//
//  UpGradientPanel.swift
//  reshape
//
//  Created by Иван Фомин on 17.04.2022.
//

import UIKit

class UpGradientPanel: UIView {
    private let gradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.greenColor!.cgColor, UIColor.darkGreenColor!.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 40
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
//        layer.shadowColor = UIColor.shadowColor!.cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.layer.addSublayer(gradient)
    }
    
    func setupGradient(withColor color: [CGColor]) {
        self.layoutIfNeeded()
        gradient.frame = self.bounds
        gradient.colors = color
    }
}
