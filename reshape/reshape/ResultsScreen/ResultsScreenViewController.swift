//
//  ResultsScreenViewController.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import UIKit

final class ResultsScreenViewController: UIViewController {
	private let output: ResultsScreenViewOutput

    init(output: ResultsScreenViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        view.backgroundColor = .red
	}
}

extension ResultsScreenViewController: ResultsScreenViewInput {
}
