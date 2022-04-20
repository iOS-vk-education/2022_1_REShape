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
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func changeState() {
        self.layoutIfNeeded()
        gradient.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.layer.addSublayer(gradient)
    }
    
    func setupGradientColor(withColor color: [CGColor]) {
        gradient.colors = color
    }
}
   
extension UpGradientPanel {
    func setupGradientDirection(withDirection direction: GradientType = .mainDiagonal) {
        gradient.startPoint = direction.start
        gradient.endPoint = direction.end
    }
}
