//
//  PhotoProgressView.swift
//  reshape
//
//  Created by Veronika on 29.03.2022.
//

import Foundation
import UIKit

final class PhotoProgressView: UIView {
    private let personImage: UIImageView = {
        let personImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 119, height: 119))
        personImage.translatesAutoresizingMaskIntoConstraints = false
        personImage.layer.cornerRadius = personImage.frame.width / 2
        personImage.clipsToBounds = true
        personImage.image = UIImage(named: "person")
        return personImage
    }()
    private let progressBar: CircularProgressBarView = CircularProgressBarView(frame:CGRect(x: 0,
                                                                                             y: 0,
                                                                                             width: 130,
                                                                                             height: 130))
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
        setupUI()
    }
}
extension PhotoProgressView{
    func setupConstraints(){
        self.addSubview(personImage)
        self.addSubview(progressBar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        personImage.centerX()
        personImage.centerY()
        personImage.height(personImage.bounds.height)
        personImage.width(personImage.bounds.width)
        progressBar.center = self.center
        progressBar.centerY()
        progressBar.centerX()
        progressBar.height(130)
        progressBar.width(130)
    }
    func setupUI(){
        progressBar.progressColor = UIColor.blueColor
        progressBar.circleColor = UIColor.blueColor.withAlphaComponent(0)
        progressBar.tag = 101
        self.perform(#selector(animateProgress), with: nil, afterDelay: 0.3)
    }
    @objc
    func animateProgress() {
        let cp = self.viewWithTag(101) as! CircularProgressBarView
        cp.setProgressWithAnimation(duration: 1.0, value: 0.75)
    }
}
