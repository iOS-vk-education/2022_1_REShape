//
//  ResultCollectionCell.swift
//  reshape
//
//  Created by Veronika on 03.04.2022.
//

import UIKit

class ResultCollectionCell: UICollectionViewCell {

    @IBOutlet weak var percentLabel: UILabel!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var targetLabel: UILabel!
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    private let progressBar: CircularProgressBarView = CircularProgressBarView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    static let reuseID = String(describing: ResultCollectionCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
        self.backgroundColor = UIColor.backgroundGrayColor.withAlphaComponent(0.3)
    }
    func setupConstraints(){
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(progressBar)
        progressBar.top(20, isIncludeSafeArea: false)
        NSLayoutConstraint.activate([
            progressBar.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 23)
        ])
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    func configure(category: String, target: String, result: String, percent: String, color: String, valueOfprogress: Float){
        categoryLabel?.text = category
        targetLabel?.text = "Цель: \(target)"
        resultLabel?.text = "Выполнено: \(result)"
        percentLabel?.text = "\(percent)"
        progressBar.progressColor = UIColor(named: color) ?? .gray
        progressBar.circleColor = .lightGrayColor
        progressBar.setProgressWithAnimation(duration: 1, value: valueOfprogress)
    }

}
