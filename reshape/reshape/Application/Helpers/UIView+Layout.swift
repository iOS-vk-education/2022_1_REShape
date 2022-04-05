//
//  UIView+Layout.swift
//  reshape
//
//  Created by Veronika on 21.03.2022.
//

import Foundation

import UIKit

extension UIView {
    func top(_ constant: CGFloat = 0.0, isIncludeSafeArea include: Bool) {
        if include {
            self.topAnchor.constraint(equalTo: self.superview!.safeAreaLayoutGuide.topAnchor,
                                      constant: constant).isActive = true
        } else {
            self.topAnchor.constraint(equalTo: self.superview!.topAnchor,
                                      constant: constant).isActive = true
        }
    }

    func bottom(_ constant: CGFloat = 0.0, isIncludeSafeArea include: Bool) {
        if include {
            self.bottomAnchor.constraint(equalTo: self.superview!.safeAreaLayoutGuide.bottomAnchor,
                                      constant: constant).isActive = true
        } else {
            self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor,
                                      constant: constant).isActive = true
        }
    }


    func leading(_ constant: CGFloat = 0.0) {
        self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor,
                                      constant: constant).isActive = true
    }

    func trailing(_ constant: CGFloat = 0.0) {
        self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor,
                                       constant: constant).isActive = true
    }

    func horizontal(_ leading: CGFloat = 0.0, trailing: CGFloat = 0.0) {
        self.leading(leading)
        self.trailing(trailing)
    }

    func vertical(_ top: CGFloat = 0.0, bottom: CGFloat = 0.0) {
        self.top(top, isIncludeSafeArea: false)
        self.bottom(bottom, isIncludeSafeArea: false)
    }

    func centerY() {
        self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor).isActive = true
    }
    func centerX() {
        self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor).isActive = true
    }
    func height(_ height: CGFloat = 0.0){
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    func width(_ width: CGFloat = 0.0){
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    /// Закрепление на все 4 констреинта с учетом отсупов (верх, лево, право, низ)
    func pins(_ insets: UIEdgeInsets = .zero) {
        self.top(insets.top, isIncludeSafeArea: false)
        self.leading(insets.left)
        self.trailing(insets.right)
        self.bottom(insets.bottom, isIncludeSafeArea: false)
    }
}
