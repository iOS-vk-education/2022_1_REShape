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
        addGestureRecognizer()
        
	}
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(upGradientPanel)
        view.addSubview(navBarView)
        view.addSubview(addTable)
        view.addSubview(addLabel)
        setupTableView()
    }

    
    private func setupNavigation() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navBarView.delegate = self
        navBarView.setConfigForWeightScreen(withName: defaults.string(forKey: "name") ?? "Unnamed")
    }
    
    private func setupGradientPanel() {
        upGradientPanel.setupGradientColor(withColor: [UIColor.greenColor!.cgColor,
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
        addTable.register(DateTimeCell.self)
        addTable.register(WeightCell.self)
        addTable.delegate = self
        addTable.dataSource = self
        addTable.isScrollEnabled = false
        addTable.contentInset.top = -32
    }
}

extension WeightViewController: WeightViewInput {
    func reloadData() {
        addTable.reloadSections(IndexSet(integer: 0), with: .none)
    }
    
    func startEditing() {
        // For date
        guard let cellDate = addTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? DateTimeCell else { return }
        cellDate.setData(stringForData: Date().dateString())
        
        // For time
        guard let cellTime = addTable.cellForRow(at: IndexPath(row: 1, section: 0)) as? DateTimeCell else { return }
        cellTime.setData(stringForData: Date().timeString())
    }
    
    func endEditing(withWeight weight: Int) {
        view.endEditing(true)
        output.uploadNewWeight(newDate: Date().dateString(),
                               newTime: Date().timeString(),
                               newWeight: weight)
    }
    
    func cancelEditing() {
        view.endEditing(true)
        // For date
        guard let cellDate = addTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? DateTimeCell else { return }
        cellDate.setData(stringForData: output.getLastDate())
        
        // For time
        guard let cellTime = addTable.cellForRow(at: IndexPath(row: 1, section: 0)) as? DateTimeCell else { return }
        cellTime.setData(stringForData: output.getLastTime())
        
        // For weight
        guard let cellWeight = addTable.cellForRow(at: IndexPath(row: 2, section: 0)) as? WeightCell else { return }
        cellWeight.setData(stringForData: output.getLastWeight())
    }
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
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueCell(cellType: DateTimeCell.self, for: indexPath)
            cell.setData(stringForCell: "Дата", stringForData: output.getLastDate())
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueCell(cellType: DateTimeCell.self, for: indexPath)
            cell.setData(stringForCell: "Время", stringForData: output.getLastTime())
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueCell(cellType: WeightCell.self, for: indexPath)
            cell.setData(stringForCell: "Вес", stringForData: output.getLastWeight())
            cell.view = self
            cell.selectionStyle = .none
            return cell
        default:
            break
        }
        return .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            guard let cell = addTable.cellForRow(at: indexPath) as? WeightCell else { return }
            cell.tapped()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33
    }
}

extension WeightViewController {
    func addGestureRecognizer() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTap)
    }

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let cell = addTable.cellForRow(at: IndexPath(row: 2, section: 0)) as? WeightCell else { return }
        cell.unchosen()
    }
}
