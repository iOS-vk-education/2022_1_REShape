//
//  DataSnapshotExtension.swift
//  reshape
//
//  Created by Veronika on 29.05.2022.
//  Created by Полина Константинова on 31.05.2022.
//

import Foundation
import Firebase

extension DataSnapshot {
    var data: Data? {
        guard let value = value, !(value is NSNull) else { return nil }
        return try? JSONSerialization.data(withJSONObject: value)
    }
}
