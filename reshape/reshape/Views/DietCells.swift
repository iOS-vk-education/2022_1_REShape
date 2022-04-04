//
//  DietTableViewController.swift
//  reshape
//
//  Created by Иван Фомин on 29.03.2022.
//

import UIKit

enum MealsType {
    case breakfast, lunch, dinner, none,
         mealBreakfast, mealLunch, mealDinner
}

struct Meals {
    var name: String
    var cal: Double
    
    init(mealName: String, calories: Double) {
        name = mealName
        cal = calories
    }
}

final class DietCell: UITableViewCell {
    private let mealTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Dark Violet")
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private var disclosureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.addSubview(mealTypeLabel)
        self.addSubview(disclosureImage)
        backgroundColor = UIColor(named: "ModalViewColor")
        setupConstraints()
    }
    
    private func setupConstraints() {
        mealTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        mealTypeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 11).isActive = true
        mealTypeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        mealTypeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 36).isActive = true
        mealTypeLabel.height(17)
        
        disclosureImage.translatesAutoresizingMaskIntoConstraints = false
        disclosureImage.width(6)
        disclosureImage.height(14)
        disclosureImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        disclosureImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mealTypeLabel.text = ""
        disclosureImage.image = UIImage()
    }
    
    func setText(_ text: String) {
        mealTypeLabel.text = text
    }
    
    func disclosure(_ discl: Bool) {
        if discl {
//            disclosureImage.rotateClockwise()
            disclosureImage.image = UIImage(named: "Closure")
            disclosureImage.transform = disclosureImage.transform.rotated(by: Double.pi/2)
        } else {
//            disclosureImage.rotateAntiClockwise()
            disclosureImage.image = UIImage(named: "Closure")
        }
    }
}

final class MealCell: UITableViewCell {
    private var checkCircleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "notRememberButton")
        return imageView
    }()
    
    private var mealNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Dark Violet")
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private var caloriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Dark Violet")
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
    
    func setupCell() {
        self.addSubview(checkCircleImage)
        self.addSubview(mealNameLabel)
        self.addSubview(caloriesLabel)
        backgroundColor = UIColor(named: "ModalViewColor")
        setupConstarints()
    }
    
    func setupConstarints() {
        checkCircleImage.translatesAutoresizingMaskIntoConstraints = false
        checkCircleImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 11).isActive = true
        checkCircleImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkCircleImage.height(12)
        checkCircleImage.width(12)
    }
}

extension UIImageView {
    func rotateClockwise() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = transform.rotated(by: 0)
        rotation.toValue = transform.rotated(by: Double.pi/2)
        rotation.duration = 0.5
        self.layer.add(rotation, forKey: "rotationClockwiseAnimation")
    }

    func rotateAntiClockwise() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = transform.rotated(by: 0)
        rotation.toValue = transform.rotated(by: -Double.pi/2)
        rotation.duration = 0.5
        self.layer.add(rotation, forKey: "rotationAntiClockwiseAnimation")
    }
}
