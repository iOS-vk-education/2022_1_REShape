//
//  GenderButton.swift
//  reshape
//
//  Created by Veronika on 06.04.2022.
//

import Foundation
import UIKit

final class GenderButton: UIView {
    var action: (() -> Void)?
    
    var label: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")        
    }

}
extension GenderButton{
    func setupConstraints(){
        self.addSubview(label)
        label.centerX()
        label.centerY()
    }
    func setupUI(title: String){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .modalViewGrayColor
        self.label.text = title
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(buttonTapped))
        gestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(gestureRecognizer)

    }
    @objc
    func buttonTapped() {
        action?()
    }
}
