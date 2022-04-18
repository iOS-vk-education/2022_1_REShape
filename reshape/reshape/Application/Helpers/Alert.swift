//
//  Alert.swift
//  reshape
//
//  Created by Veronika on 16.04.2022.
//

import Foundation
import UIKit

extension UIViewController{
    func makeAlert(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
