//
//  GenderCell.swift
//  reshape
//
//  Created by Veronika on 05.04.2022.
//

import Foundation
import UIKit

final class GenderStackView: UIView {
    
    private lazy var genderLabel: UILabel = {
        let gender = UILabel()
        gender.translatesAutoresizingMaskIntoConstraints = false
        gender.text = "Пол"
        gender.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        gender.textColor = .black
        return gender
    }()
    private let manButton: GenderButton = GenderButton()
    private let womanButton: GenderButton = GenderButton()
    private let buttonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.spacing = 40
        buttonStackView.axis = .horizontal
        return buttonStackView
    }()
    private let genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    private(set) var isSelectedItem: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupConstraints()
        self.setupUI()
    }
}
extension GenderStackView{
    private func setupConstraints(){
        
        self.addSubview(genderStackView)
        genderStackView.addArrangedSubview(genderLabel)
        genderStackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(manButton)
        buttonStackView.addArrangedSubview(womanButton)
        
        genderStackView.top(isIncludeSafeArea: false)
        genderStackView.leading()
        genderStackView.trailing()
        
        genderLabel.leading()
        genderLabel.height(19)
        
        buttonStackView.leading()
        buttonStackView.trailing()
        buttonStackView.height(42)
        
        manButton.width(153)
        manButton.height(42)
        
        womanButton.width(153)
        womanButton.height(42)
    }
    private func setupUI(){
        manButton.setupUI(title: "Mуж")
        manButton.tag = 1
        manButton.action = {
            self.isSelectedItem = true
            self.selectItem(selected: self.manButton.tag)
        }

        manButton.isUserInteractionEnabled = true
        womanButton.setupUI(title: "Жен")
        womanButton.tag = 2
        womanButton.action = {
            self.isSelectedItem = true
            self.selectItem(selected: self.womanButton.tag)
        }
    }
    private func selectItem(selected: Int){
        switch selected {
        case 1:
            manButton.backgroundColor = .violetColor
            manButton.label.textColor = .white
            womanButton.backgroundColor = .modalViewGrayColor
            womanButton.label.textColor = .black
        case 2:
            womanButton.backgroundColor = .violetColor
            womanButton.label.textColor = .white
            manButton.backgroundColor = .modalViewGrayColor
            manButton.label.textColor = .black
        default: break
        }
        
    }

}
