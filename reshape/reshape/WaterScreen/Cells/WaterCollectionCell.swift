//
//  WaterCollectionCell.swift
//  reshape
//
//  Created by Полина Константинова on 19.04.2022.
//

import UIKit

protocol WaterCollectionCellDelegate: AnyObject {
    func endEditingTextField(_ textField: UITextField) -> Bool
}

class WaterCollectionCell: UICollectionViewCell {
    
    weak var delegate: WaterCollectionCellDelegate?

    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var cupImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
        self.backgroundColor = UIColor.backgroundGrayColor?.withAlphaComponent(0.3)
    }
    
    func setupConstraints() {
        self.layer.masksToBounds = true
    }
    
    func configure(cup: UIImage, water: String, volume: String){
        waterLabel?.text = water
        volumeLabel?.text = volume
        cupImage?.image = cup
    }
}
