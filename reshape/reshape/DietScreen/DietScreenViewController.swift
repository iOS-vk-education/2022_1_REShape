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
        label.textColor = UIColor.blackVioletColor
        label.numberOfLines = 1
        return label
    }()

    private var dietSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchTextField.attributedPlaceholder =
        NSAttributedString(string: "ПОИСК ПО ДНЯМ",
                           attributes: [NSAttributedString.Key.kern: 0.77,
                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular),
                                        NSAttributedString.Key.foregroundColor: UIColor.pureGreyColor!])
        search.searchBarStyle = .minimal
        search.setPositionAdjustment(UIOffset(horizontal: 9, vertical: 0.5), for: .search)
        search.searchTextPositionAdjustment = UIOffset(horizontal: 9, vertical: 0.5)
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
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(dietLabel)
        
        // Настройка SearchBar
        view.addSubview(dietSearchBar)
        dietSearchBar.delegate = self
        
        // Настройка TableView
        view.addSubview(dietTableView)
        setupTableView()
    }
    
    func setupConstraint() {
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
    
    func setupTableView() {
        // Загрузка и обработка данных в Presenterе
        output.initCellData()
        
        // Настройка визуала
        dietTableView.backgroundColor = .white
        dietTableView.separatorStyle = .singleLine
        dietTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 1, right: 16)
        dietTableView.separatorColor = .white
        
        // Настройка действий с таблицей
        dietTableView.delegate = self
        dietTableView.dataSource = self
        dietTableView.register(DietCell.self)
        dietTableView.register(MealCell.self)
        dietTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Day") // TODO
    }
    
}
extension DietScreenViewController: DietScreenViewInput {
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
}

extension DietScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let mealType = output.getMealType(from: indexPath)
        switch mealType {
        case .breakfast, .lunch, .dinner:
            let cell = tableView.dequeueCell(cellType: DietCell.self, for: indexPath)
            
            // Получение и установка данных для текущей ячейки
            let cellData = output.getCellData(forMeal: mealType, atSection: indexPath.section)
            cellData.disclosureState ? cell.disclosure(animated: false) : cell.closure(animated: false)
            cell.setText(mealType.text)
            
            return cell
        case .mealBreakfast, .mealLunch, .mealDinner:
            let cell = tableView.dequeueCell(cellType: MealCell.self, for: indexPath)
            
            // Получение позиции родительской ячейки и блока данных
            let dietCellIndex = output.getCellIndex(forMeal: mealType.revert, atSection: indexPath.section)
            let dietCellData = output.getCellData(forMeal: mealType.revert, atSection: indexPath.section)
            
            // Проверка на размер блока данных
            if indexPath.row - dietCellIndex > dietCellData.meals.count {
                return .init()
            }
            
            // Получение данных для текущей ячейки
            let currentMealCell = dietCellData.meals[indexPath.row - dietCellIndex - 1]
            cell.setMealInformation(currentMealCell.name, calories: currentMealCell.cal, state: currentMealCell.checked)
            
            return cell
        case .none:
            return .init()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Day")
        
        var contentConfiguration = header!.defaultContentConfiguration()
        contentConfiguration.text = "День \(section + 1)"
        contentConfiguration.textProperties.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        contentConfiguration.textProperties.color = UIColor.violetColor ?? .systemPurple
        
        header?.contentConfiguration = contentConfiguration
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 28 : 41
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        33
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let mealType = output.getMealType(from: indexPath)
        switch mealType {
        case .breakfast, .lunch, .dinner:
            // Получение блока данных
            let dietCellData = output.getCellData(forMeal: mealType, atSection: indexPath.section)
            
            // Проверка и изменение состояния
            if dietCellData.disclosureState {
                (cell as? DietCell)?.closure()
                output.uncheckedDiet(mealType: mealType, inSection: indexPath.section)
            } else {
                (cell as? DietCell)?.disclosure()
                output.checkedDiet(mealType: mealType, inSection: indexPath.section)
                output.updateMealList(day: indexPath.section + 1, mealtype: mealType)
            }
        case .mealLunch, .mealDinner, .mealBreakfast:
            // Получение позиции родительской ячейки
            let dataCellIndex = output.getCellIndex(forMeal: mealType.revert, atSection: indexPath.section)
            
            // Расчет индекса блюда в списке
            let currentMealIndex = indexPath.row - dataCellIndex - 1
            
            // Получение данных о блюде
            let mealData = output.getCellData(forMeal: mealType.revert, atSection: indexPath.section).meals[currentMealIndex]
            

            
            // Проверка состояния блюда и изменение его состояния
            if mealData.checked {
                (cell as? MealCell)?.setState(at: false)
                output.uncheckedMeal(atPosition: currentMealIndex, forMeal: mealType, inSection: indexPath.section)
            } else {
                (cell as? MealCell)?.setState(at: true)
                output.checkedMeal(atPosition: currentMealIndex, forMeal: mealType, inSection: indexPath.section)
            }
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: .random())
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.getNumOfRows(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        output.getNumOfDay()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension DietScreenViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
