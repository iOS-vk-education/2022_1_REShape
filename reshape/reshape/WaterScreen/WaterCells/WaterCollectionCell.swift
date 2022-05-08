//
//  WaterCollectionCell.swift
//  reshape
//
//  Created by Полина Константинова on 19.04.2022.
//

import UIKit

class WaterCollectionCell: UICollectionViewCell {
        
    weak var view: WaterScreenViewInput?
    
    @IBOutlet weak var mlLabel: UILabel!
    @IBOutlet weak var volumeTextField: UITextField!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var cupImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
        self.backgroundColor = UIColor.backgroundGrayColor?.withAlphaComponent(0.3)
    }
    
    func setupConstraints() {
        self.layer.masksToBounds = true
        volumeTextField.borderStyle = .none
        volumeTextField.keyboardType = .numberPad
        
    }
    
    func configure(cup: UIImage, water: String, volume: String) {
        waterLabel?.text = water
        volumeTextField?.text = volume
        cupImage?.image = cup
    }
}

extension WaterCollectionCell {
    func unchosen() {
        volumeTextField.endEditing(false)
    }
}
