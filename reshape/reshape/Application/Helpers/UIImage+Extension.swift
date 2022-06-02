//
//  UIImage+Extension.swift
//  reshape
//
//  Created by Иван Фомин on 11.04.2022.
//

import UIKit

extension UIImageView {
    func rotateClockwise() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = -Double.pi/2
        rotation.toValue = 0
        rotation.duration = 0.2
        self.layer.add(rotation, forKey: nil)
    }
    
    func rotateAntiClockwise() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = Double.pi/2
        rotation.toValue = 0
        rotation.duration = 0.2
        self.layer.add(rotation, forKey: nil)
    }
    func loadImage(photoURL: URL){
        
        let dataTask = URLSession.shared.dataTask(with: photoURL) { [weak self] (data, _, _) in
            if let data = data {
                // Create Image and Update Image View
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
        }
        // Start Data Task
        dataTask.resume()
    }
}
