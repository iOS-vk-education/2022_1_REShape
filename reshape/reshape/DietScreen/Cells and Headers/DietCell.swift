//
//  DietTableViewController.swift
//  reshape
//
//  Created by Иван Фомин on 29.03.2022.
//

import UIKit

final class DietCell: AbstractCell {
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
        self.addSubview(disclosureImage)
        setupConstraints()
    }
    
    private func setupConstraints() {
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
        disclosureImage.image = nil
    }
}

extension DietCell {
    func setData(text: String, state: DisclosureState, isCurrent flag: Bool = false) {
        self.setCellText(text)
        backgroundColor = flag ? .greyViolet : .modalViewGrayColor
        self.disclosure(state, animated: false)
    }
    
    func disclosure(_ state: DisclosureState, animated: Bool = true) {
        switch state {
        case .closure:
            if animated {
                disclosureImage.rotateAntiClockwise()
            }
            disclosureImage.image = UIImage(named: "Closure")
            disclosureWidthConstraints.constant = 6
            disclosureHeightConstraints.constant = 14
        case .reload:
            return
        case .disclosure:
            if animated {
                disclosureImage.rotateClockwise()
            }
            disclosureImage.image = UIImage(named: "Disclosure")
            disclosureWidthConstraints.constant = 14
            disclosureHeightConstraints.constant = 6
        }
    }
}
