//
//  ResultsNetworkManagerProtocol.swift
//  reshape
//
//  Created by Veronika on 29.05.2022.
//

import Foundation
protocol ResultsNetworkManagerProtocol: AnyObject {
    func getUserData(completion: @escaping (Result<(Data, Int), Error>) -> ())
}
