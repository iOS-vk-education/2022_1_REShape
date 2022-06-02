//
//  ReuseIdentifier.swift
//  reshape
//
//  Created by Veronika on 03.04.2022.
//

import UIKit

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifiable {}

extension UITableViewHeaderFooterView: ReuseIdentifiable {}

extension UICollectionReusableView: ReuseIdentifiable {}

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier,
                for: indexPath) as? T else {
            fatalError("Can't deque")
        }
        return cell
    }
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        self.register(UINib(nibName: cellType.nibName, bundle: nil), forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
}

extension UITableView {
    func dequeueCell<T: UITableViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier,
                for: indexPath) as? T else {
            fatalError("Can't deque")
        }
        return cell
    }
    
    func dequeueHeader<T: UITableViewHeaderFooterView>(headerType: T.Type) -> T {
        guard let header = self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Can't deque")
        }
        return header
    }

    func register<T: UITableViewCell>(_ cellType: T.Type) {
        self.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_ headerType: T.Type) {
        self.register(headerType, forHeaderFooterViewReuseIdentifier: headerType.reuseIdentifier)
    }
}
