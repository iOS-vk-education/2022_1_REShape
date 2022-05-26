//
//  DietScreenViewController.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//
//

import UIKit

final class DietScreenViewController: UIViewController {
    private let output: DietScreenViewOutput
    
    private var dietLabel: UILabel = {
        let label = UILabel()
        label.text = "РАЦИОНЫ ПИТАНИЯ"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.darkVioletColor
        label.numberOfLines = 1
        return label
    }()

    private var dietSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchTextField.attributedPlaceholder =
        NSAttributedString(string: "ПОИСК ПО ДНЯМ И БЛЮДАМ",
                           attributes: [NSAttributedString.Key.kern: 0.77,
                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular),
                                        NSAttributedString.Key.foregroundColor: UIColor.pureGreyColor as Any])
        search.searchTextField.autocapitalizationType = .none
        search.searchBarStyle = .minimal
        search.setPositionAdjustment(UIOffset(horizontal: 9, vertical: 0.5), for: .search)
        search.searchTextPositionAdjustment = UIOffset(horizontal: 9, vertical: 0.5)
        search.searchTextField.clearButtonMode = .always
        return search
    }()
    
    private let dietTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    
    init(output: DietScreenViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка отображения компонентов
        setupUI()
        // Настройка AutoLayout
        setupConstraint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.requestData()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        scrollToCurrentDay()
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        output.saveData()
    }
    
    private func scrollToCurrentDay() {
        let section = output.getCurrentDay()
        guard dietTableView.numberOfSections > section else { return }
        dietTableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(dietLabel)
        
        // Настройка SearchBar
        view.addSubview(dietSearchBar)
        dietSearchBar.delegate = self
        dietSearchBar.searchTextField.delegate = self
        
        // Настройка TableView
        view.addSubview(dietTableView)
        setupTableView()
    }
    
    private func setupConstraint() {
        dietLabel.translatesAutoresizingMaskIntoConstraints = false
        dietLabel.top(isIncludeSafeArea: true)
        dietLabel.centerX()
        dietLabel.width(172)
       
        dietSearchBar.translatesAutoresizingMaskIntoConstraints = false
        dietSearchBar.top(40, isIncludeSafeArea: true)
        dietSearchBar.trailing(-9)
        dietSearchBar.leading(9)
        dietSearchBar.height(36)
        
        dietTableView.translatesAutoresizingMaskIntoConstraints = false
        dietTableView.bottom(isIncludeSafeArea: true)
        dietTableView.trailing(0)
        dietTableView.leading(0)
        
        NSLayoutConstraint.activate([
            dietLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 19),
            dietTableView.topAnchor.constraint(equalTo: dietSearchBar.bottomAnchor, constant: 21)
        ])
    }
    
    private func setupTableView() {
        // Настройка визуала
        dietTableView.backgroundColor = .white
        dietTableView.separatorStyle = .singleLine
        dietTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        dietTableView.separatorColor = .white
        
        // Настройка действий с таблицей
        dietTableView.delegate = self
        dietTableView.dataSource = self
        dietTableView.register(DietCell.self)
        dietTableView.register(MealCell.self)
        dietTableView.register(DietHeader.self)
    }
    
}
extension DietScreenViewController: DietScreenViewInput {
    func reSearch() {
        self.searchBar(dietSearchBar, textDidChange: dietSearchBar.text ?? "")
    }
    
    func showCells(for indexPaths: [IndexPath]) {
        dietTableView.beginUpdates()
        dietTableView.insertRows(at: indexPaths, with: .bottom)
        dietTableView.endUpdates()
    }
    
    func hideCells(for indexPaths: [IndexPath]) {
        dietTableView.beginUpdates()
        dietTableView.deleteRows(at: indexPaths, with: .top)
        dietTableView.endUpdates()
    }
    
    func reloadTableView() {
        dietTableView.reloadData()
    }
    
    func reloadTableRows(atIndex indexPaths: [IndexPath], animation: UITableView.RowAnimation) {
        self.dietTableView.reloadRows(at: indexPaths, with: animation)
    }
}

extension DietScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mealType = output.getCellType(from: indexPath)
        let section = indexPath.section
        let current = output.getCurrentDay() == section ? true : false
        switch mealType {
        case .breakfast, .lunch, .dinner, .snack:
            let cell = tableView.dequeueCell(cellType: DietCell.self, for: indexPath)
            cell.setData(
                text: mealType.text,
                state: output.disclosureAllow ?
                    output.getCellDisclosure(forMeal: mealType, atSection: section) :
                    .disclosure,
                isCurrent: current)
            return cell
        case .mealBreakfast, .mealLunch, .mealDinner, .mealSnack:
            let cell = tableView.dequeueCell(cellType: MealCell.self, for: indexPath)
            cell.setMealInformation(
                name: output.getMealName(forMeal: mealType.revert, atIndex: indexPath),
                calories: output.getMealCalories(forMeal: mealType.revert, atIndex: indexPath),
                state: output.getMealState(forMeal: mealType.revert, atIndex: indexPath),
                isCurrent: current)
            return cell
        default:
            return .init()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeader(headerType: DietHeader.self)
        header.setDay(output.getDay(for: section))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 28 : 41
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: .random())
        let cell = tableView.cellForRow(at: indexPath)
        let mealType = output.getCellType(from: indexPath)
        switch mealType {
        case .breakfast, .lunch, .dinner, .snack:
            // Получение блока данных
            let newCellDisclosureState = output.getCellDisclosure(forMeal: mealType, atSection: indexPath.section).revert
            
            // Проверка и изменение состояния
            if output.disclosureAllow {
                (cell as! DietCell).disclosure(newCellDisclosureState)
                output.clickedDiet(newCellDisclosureState, mealType: mealType, inSection: indexPath.section)
            }
        case .mealLunch, .mealDinner, .mealBreakfast, .mealSnack:
            // Запрос на изменение состояния
            output.clickedMeal(forMeal: mealType.revert, atIndex: indexPath)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.getNumOfRows(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return output.getNumOfDay()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension DietScreenViewController: UISearchBarDelegate, UITextFieldDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output.searchStart(forString: searchText)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        output.searchEnd()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
