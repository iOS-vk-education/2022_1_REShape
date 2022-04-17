//
//  WeightViewController.swift
//  reshape
//
//  Created by Иван Фомин on 15.04.2022.
//  
//

import UIKit

final class WeightViewController: UIViewController, UIGestureRecognizerDelegate {
	private let output: WeightViewOutput
    
    private let navBarView: NavigationBarView = {
        let navBar = NavigationBarView()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    private let upGradientPanel: UpGradientPanel = {
        let upPanel = UpGradientPanel()
        upPanel.translatesAutoresizingMaskIntoConstraints = false
        return upPanel
    }()
    

    init(output: WeightViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        setupNavigation()
        setupUI()
        setupConstraints()
        setupGradientPanel()
        
	}
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(upGradientPanel)
        view.addSubview(navBarView)
    }
    
    private func setupNavigation() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navBarView.delegate = self
        navBarView.setConfigForWeightScreen(withName: "Иван")
    }
    
    private func setupGradientPanel() {
        upGradientPanel.setupGradient(withColor: [UIColor.greenColor!.cgColor,
                                                  UIColor.darkGreenColor!.cgColor])
    }

    private func setupConstraints() {
        navBarView.top(isIncludeSafeArea: true)
        navBarView.leading()
        navBarView.trailing()
        navBarView.heightAnchor.constraint(equalToConstant: 29).isActive = true
        
        upGradientPanel.top(isIncludeSafeArea: false)
        upGradientPanel.trailing()
        upGradientPanel.leading()
        upGradientPanel.height(view.bounds.height / 2.5)
    }
    
    @objc
    func swipeToBack(_ gesture: UIScreenEdgePanGestureRecognizer) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

extension WeightViewController: WeightViewInput {
}

extension WeightViewController: NavigationBarDelegate {
    func backButtonAction() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.navBarView.alpha = 0.7
        } completion: { [weak self] finished in
            if finished {
                self?.output.backButtonPressed()
            }
        }
    }
}
