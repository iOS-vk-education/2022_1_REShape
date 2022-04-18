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
    
    private let addLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.attributedText = NSAttributedString(string: "Добавление данных:", attributes: [NSAttributedString.Key.kern: 0.77])
        return label
    }()
    
    private let addTable = UITableView(frame: .zero, style: .insetGrouped)

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
        view.addSubview(addLabel)
        view.addSubview(addTable)
        setupTableView()
    }
    
    private func setupNavigation() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navBarView.delegate = self
        navBarView.setConfigForWeightScreen(withName: defaults.string(forKey: "name") ?? "Unnamed")
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
        
        addLabel.topAnchor.constraint(equalTo: upGradientPanel.bottomAnchor, constant: 16).isActive = true
        addLabel.leading(32)
        
        addTable.translatesAutoresizingMaskIntoConstraints = false
        addTable.topAnchor.constraint(equalTo: addLabel.bottomAnchor, constant: 16).isActive = true
        addTable.leading()
        addTable.trailing()
        addTable.bottom(isIncludeSafeArea: true)
    }
    
    func setupTableView() {
        addTable.backgroundColor = .white
        addTable.separatorStyle = .singleLine
        addTable.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        addTable.separatorColor = .white
        addTable.register(WeightCell.self)
        addTable.delegate = self
        addTable.dataSource = self
        addTable.isScrollEnabled = false
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

extension WeightViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = output.getLastWeightData()
        let cell = tableView.dequeueCell(cellType: WeightCell.self, for: indexPath)
        switch indexPath.row {
        case 0:
            cell.setData(stringForCell: "Дата", stringForData: data.getDateString())
        case 1:
            cell.setData(stringForCell: "Время", stringForData: data.getTimeString())
        case 2:
            cell.setData(stringForCell: "Вес", stringForData: "\(data.getWeight())")
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            // For day
            guard let cellDate = addTable.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as? WeightCell else { return }
            cellDate.setData(stringForData: WeightDataModel.convertToDateString(fromDate: Date()))
            
            // For time
            guard let cellTime = addTable.cellForRow(at: IndexPath(row: 1, section: indexPath.section)) as? WeightCell else { return }
            cellTime.setData(stringForData: WeightDataModel.convertToTimeString(fromDate: Date()))
            
            // For weight
            guard let cellWeight = addTable.cellForRow(at: indexPath) as? WeightCell else { return }
            cellWeight.isEditing = true
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
