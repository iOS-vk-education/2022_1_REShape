//
//  MealCell.swift
//  reshape
//
//  Created by Иван Фомин on 05.04.2022.
//

import UIKit

final class MealCell: AbstractCell {
    private var checkCircleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "notRememberButton")
        return imageView
    }()
    
    private var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.isHidden = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private var caloriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkVioletColor
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        caloriesLabel.text = ""
        checkCircleImage.image = UIImage(named: "notRememberButton")
    }
    
    func setupCell() {
        self.addSubview(checkCircleImage)
        self.addSubview(loadingSpinner)
        self.addSubview(caloriesLabel)
        setupConstarints()
    }
    
    func setupConstarints() {
        checkCircleImage.translatesAutoresizingMaskIntoConstraints = false
        checkCircleImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 11).isActive = true
        checkCircleImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkCircleImage.height(12)
        checkCircleImage.width(12)
        
        self.changeLeftTextConstraint(toAnchor: checkCircleImage.rightAnchor, constant: 6)
        
        caloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            caloriesLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            caloriesLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            caloriesLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        self.changeRightTextConstraint(toAnchor: caloriesLabel.leftAnchor, constant: -6)
        
        NSLayoutConstraint.activate([
            loadingSpinner.topAnchor.constraint(equalTo: checkCircleImage.topAnchor),
            loadingSpinner.leftAnchor.constraint(equalTo: checkCircleImage.leftAnchor),
            loadingSpinner.bottomAnchor.constraint(equalTo: checkCircleImage.bottomAnchor),
            loadingSpinner.rightAnchor.constraint(equalTo: checkCircleImage.rightAnchor)
        ])
    }
    
    func setMealInformation(name: String, calories: Double, state: MealState, isCurrent flag: Bool = false) {
        setCellText(name)
        backgroundColor = flag ? .greyViolet : .modalViewGrayColor
        caloriesLabel.text = "\(Int(calories)) ккал"
        setState(at: state)
    }
    
    func setState(at state: MealState) {
        loadingSpinner.stopAnimating()
        changeLeftTextConstraint(toAnchor: checkCircleImage.rightAnchor, constant: 6)
        switch state {
        case .checked:
            checkCircleImage.image = UIImage(named: "rememberButton")
        case .unchecked:
            checkCircleImage.image = UIImage(named: "notRememberButton")
        case .unavailable:
            checkCircleImage.image = nil
            changeLeftTextConstraint(toAnchor: self.leftAnchor, constant: 11)
        case .loading:
            checkCircleImage.image = nil
            loadingSpinner.startAnimating()
        }
    }
}
