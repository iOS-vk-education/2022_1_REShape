//
//  ForgetPasswordScreenRouter.swift
//  reshape
//
//  Created by Veronika on 19.03.2022.
//  
//

import UIKit

final class ForgetPasswordScreenRouter {
    var viewController: UIViewController?
}

extension ForgetPasswordScreenRouter: ForgetPasswordScreenRouterInput {
    func closeButton(){
        viewController?.dismiss(animated: true)
    }
}
