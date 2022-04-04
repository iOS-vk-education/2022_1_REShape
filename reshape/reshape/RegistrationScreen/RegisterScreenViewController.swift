//
//  RegisterScreenViewController.swift
//  reshape
//
//  Created by Veronika on 04.04.2022.
//  
//

import UIKit

final class RegisterScreenViewController: UIViewController {
    private let output: RegisterScreenViewOutput
    private let customNavigationBarView: NavigationBarView = {
        let navBar = NavigationBarView()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    init(output: RegisterScreenViewOutput) {
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
        customNavigationBarView.delegate = self
    }
}

extension RegisterScreenViewController {
    private func setupConstraints(){
        view.addSubview(customNavigationBarView)
        customNavigationBarView.top(isIncludeSafeArea: true)
        customNavigationBarView.leading()
        customNavigationBarView.trailing()
        customNavigationBarView.height(80)
        
    }
    private func setupUI(){
        
    }
}

extension RegisterScreenViewController: NavigationBarDelegate{
    func backButtonAction() {
        output.backButtonPressed()
    }
}

extension RegisterScreenViewController: RegisterScreenViewInput {
}
