//
//  DietHeader.swift
//  reshape
//
//  Created by Иван Фомин on 05.04.2022.
//

import UIKit

final class DietHeader: UITableViewHeaderFooterView {
    private let headerLabel: UILabel = {
        var label = UILabel()
        label.attributedText = NSMutableAttributedString(string: "День", attributes: [NSAttributedString.Key.kern: 0.77])
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.violetColor
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(headerLabel)
        setupConstraints()
    }
        
    private func setupConstraints() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.height(17)
        headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 27).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        headerLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 46).isActive = true
    }
    
    override func prepareForReuse() {
        headerLabel.attributedText = NSMutableAttributedString(string: "День", attributes: [NSAttributedString.Key.kern: 0.77])
    }
}

extension DietHeader {
    func setDay(_ day: Int) {
        headerLabel.attributedText = NSMutableAttributedString(string: "День \(day)", attributes: [NSAttributedString.Key.kern: 0.77])
    }
}
