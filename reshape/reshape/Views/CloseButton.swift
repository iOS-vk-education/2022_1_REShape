//
//  CloseButton.swift
//  reshape
//
//  Created by Veronika on 20.03.2022.
//

import Foundation
import UIKit

class CloseButton: UIButton {
    var action: (() -> Void)?
    private let viewControllerToClose: UIViewController?
    
    private override init(frame: CGRect) {
        self.viewControllerToClose = nil
        super.init(frame: .zero)
        setupUI()
    }
    
    init(viewControllerToClose: UIViewController) {
        self.viewControllerToClose = viewControllerToClose
        super.init()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setImage(UIImage(named: "close"),for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func closeButtonTapped(){
        action?()
    }
    
}

