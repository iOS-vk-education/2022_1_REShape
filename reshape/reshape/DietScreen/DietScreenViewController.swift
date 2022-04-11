//
//  DietScreenViewController.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import UIKit
import SwiftUI

enum MealsType {
    case breakfast, lunch, dinner, none,
         mealBreakfast, mealLunch, mealDinner
}

struct Meals {
    var name: String
    var cal: Double
    var checked: Bool
    
    init(mealName: String, calories: Double, check: Bool = false) {
        name = mealName
        cal = calories
        checked = check
    }
}

struct CellInfo {
    var section: Int
    var cellType: MealsType
    var disclosureState: Bool
    var meals: [Meals]
    
    init(_ sec: Int, initType: MealsType) {
        section = sec
        cellType = initType
        disclosureState = false
        meals = []
    }
}

final class DietScreenViewController: UIViewController {
	private let output: DietScreenViewOutput
    
    var cellData: [CellInfo] = []
    var rowInSection: [[MealsType]] = []
    var numOfSec: Int = 0
    
    private var dietLabel: UILabel = {
        let label = UILabel()
        label.text = "РАЦИОНЫ ПИТАНИЯ"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "Dark Violet")
        label.numberOfLines = 1
        return label
    }()

    private var dietSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchTextField.attributedPlaceholder =
        NSAttributedString(string: "ПОИСК ПО ДНЯМ",
                           attributes: [NSAttributedString.Key.kern: 0.77,
                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular),
                                        NSAttributedString.Key.foregroundColor: UIColor(named: "Grey for dietScreen")!])
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
        view.backgroundColor = .white
        setupUI()
        setupConstraint()
	}
    
    func setupUI() {
        view.addSubview(dietLabel)
        view.addSubview(dietSearchBar)
        view.addSubview(dietTableView)
        
        dietSearchBar.delegate = self
        
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
        numOfSec = output.getNumOfDay()
        for curSection in 0...numOfSec-1 {
            rowInSection.insert([.breakfast, .lunch, .dinner], at: curSection)
            cellData.append(contentsOf: [
                CellInfo(curSection, initType: .breakfast),
                CellInfo(curSection, initType: .lunch),
                CellInfo(curSection, initType: .dinner)
            ])
        }
        
        dietTableView.backgroundColor = .white
//        dietTableView.style = .insetGrouped
        dietTableView.delegate = self
        dietTableView.dataSource = self
        
        dietTableView.separatorStyle = .singleLine
        dietTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 1, right: 16)
        dietTableView.separatorColor = .white
        
        dietTableView.register(DietCell.self, forCellReuseIdentifier: "DietCell")
        dietTableView.register(MealCell.self, forCellReuseIdentifier: "MealCell")
        dietTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Other")
        dietTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Day") // TODO
    }
    
}
extension DietScreenViewController {
    private func prepareCells(mealType celltype: MealsType, atSection section: Int)
    -> (cellTypeForRemove: MealsType, mealDataSize: Int, dietCellIndex: Int, mealIndexPath: [IndexPath])? {
        if (rowInSection.count <= section) { return nil }
        guard let data = cellData.first(where: { $0.section == section && $0.cellType == celltype }) else { return nil }
        guard let dietCellIndex = rowInSection[section].firstIndex(of: celltype) else { return nil }

        let cellTypeForRemove = revertCellType(from: celltype)!
        let mealDataSize = data.meals.count
        if mealDataSize == 0 { return nil }
        var mealIndexPath: [IndexPath] = []
        for i in (1...mealDataSize).reversed() {
            mealIndexPath.append(IndexPath(row: dietCellIndex + i, section: section))
        }
        return (cellTypeForRemove, mealDataSize, dietCellIndex, mealIndexPath)
    }
    
    private func addCells(mealType celltype: MealsType, section: Int) {
        guard let (cellTypeForRemove, mealDataSize, dietCellIndex, mealIndexPath) = prepareCells(mealType: celltype, atSection: section) else { return }
        dietTableView.beginUpdates()
        rowInSection[section].insert(contentsOf: Array(repeating: cellTypeForRemove, count: mealDataSize), at: dietCellIndex + 1)
        dietTableView.insertRows(at: mealIndexPath, with: .bottom)
        dietTableView.endUpdates()
    }
    
    private func clearCells(mealType celltype: MealsType, section: Int) {
        guard let (cellTypeForRemove, _, _, mealIndexPath) = prepareCells(mealType: celltype, atSection: section) else { return }
        dietTableView.beginUpdates()
        rowInSection[section].removeAll(where: {$0 == cellTypeForRemove})
        dietTableView.deleteRows(at: mealIndexPath, with: .top)
        dietTableView.endUpdates()
    }
    
    private func revertCellType(from celltype: MealsType) -> MealsType? {
        switch celltype {
        case .breakfast:
            return.mealBreakfast
        case .lunch:
            return .mealLunch
        case .dinner:
            return .mealDinner
        case .mealBreakfast:
            return .breakfast
        case .mealLunch:
            return .lunch
        case .mealDinner:
            return .dinner
        default:
            return nil
        }
    }
}

extension DietScreenViewController: DietScreenViewInput {
    func setMealList(_ meals: [Meals], day: Int, celltype: MealsType) {
        if (rowInSection.count < day) { return }
        clearCells(mealType: celltype, section: day - 1)
        
        guard let dataIndex = cellData.firstIndex(where: { $0.section == day - 1 && $0.cellType == celltype }) else { return }
        
        cellData[dataIndex].meals = meals
        addCells(mealType: celltype, section: day - 1)
    }
}

extension DietScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (rowInSection.count <= indexPath.section || rowInSection[indexPath.section].count <= indexPath.row) {
            return .init()
        }
        
        let cellInfo = rowInSection[indexPath.section][indexPath.row]
        switch cellInfo {
        case .breakfast, .lunch, .dinner:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DietCell", for: indexPath) as? DietCell else {
                return .init()
            }
            guard let data = cellData.first(where: { $0.section == indexPath.section && $0.cellType == cellInfo }) else {
                return .init()
            }
            
            if data.disclosureState {
                cell.disclosure(animated: false)
            } else {
                cell.closure(animated: false)
            }
            var cellText: String = ""
            switch cellInfo {
            case .breakfast:
                cellText = "Завтрак"
            case .lunch:
                cellText = "Обед"
            case .dinner:
                cellText = "Ужин"
            default:
                cellText = ""
            }
            cell.setText(cellText)
            return cell
        case .mealBreakfast, .mealLunch, .mealDinner:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as? MealCell else {
                return .init()
            }
            
            guard let cellText = revertCellType(from: cellInfo) else {
                return .init()
            }
            if cellText == MealsType.none {
                return .init()
            }
            guard let data = cellData.first(where: { $0.section == indexPath.section && $0.cellType == cellText }) else {
                return .init()
            }
            
            let breakfastCellRow = rowInSection[indexPath.section].firstIndex(of: cellText)!
            if indexPath.row > (data.meals.count + breakfastCellRow) {
                return .init()
            }
            let currentMealCell = data.meals[indexPath.row - breakfastCellRow - 1]
            
            cell.setMealInformation(currentMealCell.name, calories: currentMealCell.cal, state: currentMealCell.checked)
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "Other", for: indexPath)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Day")
        
        var contentConfiguration = header!.defaultContentConfiguration()
        contentConfiguration.text = "День \(section + 1)"
        contentConfiguration.textProperties.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        contentConfiguration.textProperties.color = UIColor(named: "Violet") ?? .systemPurple
        
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
        if (rowInSection.count <= indexPath.section || rowInSection[indexPath.section].count <= indexPath.row) { return }
        
        let nameMealCell = rowInSection[indexPath.section][indexPath.row]
        switch nameMealCell {
        case .breakfast, .lunch, .dinner:
            guard let cell = tableView.cellForRow(at: indexPath) as? DietCell else { return }
            guard let dataIndex = cellData.firstIndex(where: { $0.section == indexPath.section && $0.cellType == nameMealCell }) else { return }
            
            if cellData[dataIndex].disclosureState {
                cell.closure()
                cellData[dataIndex].disclosureState = false
                clearCells(mealType: nameMealCell, section: indexPath.section)
            } else {
                cell.disclosure()
                cellData[dataIndex].disclosureState = true
                addCells(mealType: nameMealCell, section: indexPath.section)
                output.needMealList(day: indexPath.section + 1, mealtype: nameMealCell)
            }
        case .mealLunch, .mealDinner, .mealBreakfast:
            guard let cell = tableView.cellForRow(at: indexPath) as? MealCell else { return }
            guard let dietCellType = revertCellType(from: nameMealCell) else { return }
            guard let dataIndex = cellData.firstIndex(where: { $0.section == indexPath.section && $0.cellType == dietCellType }) else { return }
            guard let dietCellIndex = rowInSection[indexPath.section].firstIndex(of: dietCellType) else { return }
            let currentMealIndex = indexPath.row - dietCellIndex - 1
            
            if cellData[dataIndex].meals[currentMealIndex].checked {
                cellData[dataIndex].meals[currentMealIndex].checked = false
                cell.setState(at: false)
                output.uncheckedMeal(atPosition: currentMealIndex, forMeal: dietCellType, inDay: indexPath.section + 1)
            } else {
                cellData[dataIndex].meals[currentMealIndex].checked = true
                cell.setState(at: true)
                output.checkedMeal(atPosition: currentMealIndex, forMeal: dietCellType, inDay: indexPath.section + 1)
            }
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: .random())
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rowInSection.count <= section { return 0 }
        else { return rowInSection[section].count }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numOfSec
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
