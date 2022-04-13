//
//  ProfileCollectionCells.swift
//  reshape
//
//  Created by Полина Константинова on 10.04.2022.
//

import UIKit

class ProfileCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var informLabel: UILabel!
    
    
    static let reuseID = String(describing: ProfileCollectionCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
        self.backgroundColor = UIColor.backgroundGrayColor?.withAlphaComponent(0.3)
    }
    
    func setupConstraints(){
        self.layer.masksToBounds = true
    }
    
    func configure(category: String, inform: String) {
        categoryLabel?.text = category
        informLabel?.text = inform
    }

}

