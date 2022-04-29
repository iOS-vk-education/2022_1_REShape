//
//  AbstractCell.swift
//  reshape
//
//  Created by Иван Фомин on 17.04.2022.
//

import UIKit

class AbstractCell: UITableViewCell {
    private let cellName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.darkVioletColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private var leftCellNameConstraint = NSLayoutConstraint()
    private var rightCellNameConstraint = NSLayoutConstraint()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        self.addSubview(cellName)
        leftCellNameConstraint = cellName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 11)
        rightCellNameConstraint = cellName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -11)
        NSLayoutConstraint.activate([
            leftCellNameConstraint,
            rightCellNameConstraint,
            cellName.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
        ])
        cellName.height(17)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellName.text = ""
    }
    
    func setCellText(_ text: String) {
        cellName.text = text
        backgroundColor = UIColor.modalViewGrayColor
    }
    
    func changeLeftTextConstraint(toAnchor anchor: NSLayoutXAxisAnchor, constant: CGFloat) {
        NSLayoutConstraint.deactivate([leftCellNameConstraint])
        leftCellNameConstraint = cellName.leftAnchor.constraint(equalTo: anchor, constant: constant)
        NSLayoutConstraint.activate([leftCellNameConstraint])
    }
    
    func changeRightTextConstraint(toAnchor anchor: NSLayoutXAxisAnchor, constant: CGFloat) {
        NSLayoutConstraint.deactivate([rightCellNameConstraint])
        rightCellNameConstraint = cellName.rightAnchor.constraint(equalTo: anchor, constant: constant)
        NSLayoutConstraint.activate([rightCellNameConstraint])
    }
}
