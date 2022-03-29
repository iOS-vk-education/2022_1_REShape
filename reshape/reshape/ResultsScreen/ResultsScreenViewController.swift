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
    private let mainView: CustomView = CustomView()
    private let progress: CircularProgressBarView = CircularProgressBarView(
        frame: CGRect(
            x: 10.0,
            y: 30.0,
            width: 130.0,
            height: 130.0))
    init(output: ResultsScreenViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupUI()
    }
}

extension ResultsScreenViewController: ResultsScreenViewInput {
    private func setupConstraints(){
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.top(isIncludeSafeArea: false)
        mainView.leading()
        mainView.trailing()
        mainView.height(view.bounds.height / 2.5)


    }
    private func setupUI(){
        
    }

}
