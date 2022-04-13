//
//  WaterScreenViewController.swift
//  reshape
//
//  Created by Полина Константинова on 12.04.2022.
//  
//

import UIKit

final class WaterScreenViewController: UIViewController {
	private let output: WaterScreenViewOutput

    init(output: WaterScreenViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

extension WaterScreenViewController: WaterScreenViewInput {
}
