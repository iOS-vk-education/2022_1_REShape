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
}

class DietCell: UITableViewCell {
    var disclosureState = false
    var mealType: MealsType = .none
    var mealsList: [Meals] = []
    
    let mealTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Dark Violet")
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    private let background = UIView()
    private var disclosureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Closure")
        imageView.animationDuration = 0.5
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBackground()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackground() {
        self.addSubview(background)
        
        background.backgroundColor = UIColor(named: "ModalViewColor")
        background.addSubview(mealTypeLabel)
        background.addSubview(disclosureImage)
        
        setupConstraints()
        self.backgroundView = background
    }
    
    func setupConstraints() {
        mealTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        mealTypeLabel.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 11).isActive = true
        mealTypeLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 8).isActive = true
        mealTypeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 36).isActive = true
        mealTypeLabel.height(17)
        
        disclosureImage.translatesAutoresizingMaskIntoConstraints = false
        disclosureImage.width(6)
        disclosureImage.height(14)
        disclosureImage.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -16).isActive = true
        disclosureImage.topAnchor.constraint(equalTo: background.topAnchor, constant: 10).isActive = true
        
        background.translatesAutoresizingMaskIntoConstraints = false
        background.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        background.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        background.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        background.height(33)
    }
    
    func disclosure(_ discl: Bool) {
        if (discl && !disclosureState) {
            disclosureImage.rotateClockwise()
            disclosureImage.transform = transform.rotated(by: Double.pi/2)
            disclosureState = true
        } else if (!discl && disclosureState) {
            disclosureImage.rotateAntiClockwise()
            disclosureImage.transform = transform.rotated(by: -Double.pi/2)
            disclosureState = false
        }
    }
}

final class BreakfastCell: DietCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mealType = .breakfast
        mealTypeLabel.attributedText = NSAttributedString(string: "Завтрак", attributes: [NSAttributedString.Key.kern: 0.77])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupBackground() {
        super.setupBackground()
        guard let background = self.backgroundView else {
            return
        }
        background.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        background.layer.cornerRadius = 12
        
        self.backgroundView = background
    }
}

final class LunchCell: DietCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mealType = .lunch
        mealTypeLabel.attributedText = NSAttributedString(string: "Обед", attributes: [NSAttributedString.Key.kern: 0.77])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class DinnerCell: DietCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mealType = .dinner
        mealTypeLabel.attributedText = NSAttributedString(string: "Ужин", attributes: [NSAttributedString.Key.kern: 0.77])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupBackground() {
        super.setupBackground()
        guard let background = self.backgroundView else {
            return
        }
        background.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        background.layer.cornerRadius = 12
        
        self.backgroundView = background
    }
}

extension UIImageView {
    func rotateClockwise() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi/2
        rotation.duration = 0.5
        self.layer.add(rotation, forKey: "rotationClockwiseAnimation")
    }

    func rotateAntiClockwise() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = Double.pi/2
        rotation.toValue = 0
        rotation.duration = 0.5
        self.layer.add(rotation, forKey: "rotationAntiClockwiseAnimation")
    }
}
