//
//  WaterCollectionCell.swift
//  reshape
//
//  Created by Полина Константинова on 12.04.2022.
//

import UIKit

class WaterCollectionCell: UICollectionViewCell {

    @IBOutlet weak var waterLabel: UILabel!
    
    @IBOutlet weak var volumeLabel: UILabel!
    
    @IBOutlet weak var cupImage: UIImageView!
    
    static let reuseID = String(describing: WaterCollectionCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
        self.backgroundColor = UIColor.backgroundGrayColor?.withAlphaComponent(0.3)
    }
    
    func setupConstraints(){
        self.layer.masksToBounds = true
    }
    
    func configure( cup: UIImage, water: String, volume: String) {
        waterLabel?.text = water
        volumeLabel?.text = volume
        cupImage?.image = cup
    }

}
