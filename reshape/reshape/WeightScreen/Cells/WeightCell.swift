//
//  WeightCell.swift
//  reshape
//
//  Created by Иван Фомин on 17.04.2022.
//

import UIKit

final class WeightCell: AbstractCell {
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.darkVioletColor
        label.text = ""
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.addSubview(rightLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            rightLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            rightLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rightLabel.text = ""
    }
}

extension WeightCell {
    func setData(stringForCell cellText: String, stringForData dataText: String) {
        self.setCellText(cellText)
        rightLabel.text = dataText
    }
    
    func setData(stringForData dataText: String) {
        rightLabel.text = dataText
    }
}
