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
    var checked: Bool
    
    init(mealName: String, calories: Double, check: Bool = false) {
        name = mealName
        cal = calories
        checked = check
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
        imageView.image = nil
        return imageView
    }()
    
    private var disclosureWidthConstraints: NSLayoutConstraint = NSLayoutConstraint()
    private var disclosureHeightConstraints: NSLayoutConstraint = NSLayoutConstraint()
    
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
        disclosureWidthConstraints = disclosureImage.widthAnchor.constraint(equalToConstant: 6)
        disclosureHeightConstraints = disclosureImage.heightAnchor.constraint(equalToConstant: 14)
        disclosureImage.centerXAnchor.constraint(equalTo: self.rightAnchor, constant: -19).isActive = true
        disclosureImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        disclosureHeightConstraints.isActive = true
        disclosureWidthConstraints.isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mealTypeLabel.text = ""
        disclosureImage.image = nil
    }
    
    func setText(_ text: String) {
        mealTypeLabel.text = text
    }
    
    func disclosure(animated: Bool = true) {
        if animated {
            disclosureImage.rotateClockwise()
        }
        disclosureImage.image = nil
        disclosureImage.image = UIImage(named: "Disclosure")
        disclosureWidthConstraints.constant = 14
        disclosureHeightConstraints.constant = 6
    }
    
    func closure(animated: Bool = true) {
        if animated {
            disclosureImage.rotateAntiClockwise()
        }
        disclosureImage.image = nil
        disclosureImage.image = UIImage(named: "Closure")
        disclosureWidthConstraints.constant = 6
        disclosureHeightConstraints.constant = 14
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

    override func prepareForReuse() {
        super.prepareForReuse()
        mealNameLabel.text = ""
        caloriesLabel.text = ""
        checkCircleImage.image = UIImage(named: "notRememberButton")
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
        
        mealNameLabel.translatesAutoresizingMaskIntoConstraints = false
        mealNameLabel.leftAnchor.constraint(equalTo: checkCircleImage.rightAnchor, constant: 6).isActive = true
        mealNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mealNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        mealNameLabel.height(17)
        
        caloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        caloriesLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        caloriesLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        caloriesLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        caloriesLabel.height(17)
    }
    
    func setMealInformation(_ name: String, calories: Double, state: Bool) {
        mealNameLabel.text = name
        caloriesLabel.text = "\(Int(calories)) ккал"
        setState(at: state)
    }
    
    func setState(at state: Bool) {
        if state {
            checkCircleImage.image = UIImage(named: "rememberButton")
        } else {
            checkCircleImage.image = UIImage(named: "notRememberButton")
        }
    }
}

extension UIImageView {
    func rotateClockwise() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = -Double.pi/2
        rotation.toValue = 0
        rotation.duration = 0.2
        self.layer.add(rotation, forKey: "rotationClockwiseAnimation")
    }

    func rotateAntiClockwise() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = Double.pi/2
        rotation.toValue = 0
        rotation.duration = 0.2
        self.layer.add(rotation, forKey: "rotationAntiClockwiseAnimation")
    }
}
