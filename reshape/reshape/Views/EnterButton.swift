//
//  EnterButton.swift
//  reshape
//
//  Created by Иван Фомин on 18.03.2022.
//

import Foundation
import UIKit

final class EnterButton: UIButton {
    private lazy var title = String()
    
    var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(name: String) {
        title = name
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor(named: "Violet")
        self.layer.cornerRadius = 16
        self.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    @objc
    func buttonPressed() {
        action?()
    }
}
