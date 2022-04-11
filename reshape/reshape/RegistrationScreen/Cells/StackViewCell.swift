//
//  StackViewCell.swift
//  reshape
//
//  Created by Veronika on 07.04.2022.
//

import Foundation
import UIKit
protocol AuthStackViewCellDelegate: AnyObject {
    func endEditingTextField(_ textField: UITextField) -> Bool
}
protocol StackViewCellDataSource: AnyObject {}

final class StackViewCell: UITableViewCell {
    let stackView: AuthStackView = AuthStackView()
    weak var delegate: AuthStackViewCellDelegate?
    weak var dataSource: AuthStackViewDataSource? {
        didSet {
            stackView.tag = tag
            stackView.dataSource = dataSource 
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
        
    }
}
extension StackViewCell {
    func setupConstraints(){
        stackView.delegate = self
        self.contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.pins()
        stackView.backgroundTFColor = UIColor.modalViewGrayColor ?? .lightGray

    }

}

extension StackViewCell: AuthStackViewDelegate {
    func endEditingTextField(_ textField: UITextField) -> Bool {
        guard let delegate = delegate else { return false }
        return delegate.endEditingTextField(textField)
    }
}
