//
//  DietScreenViewController.swift
//  reshape
//
//  Created by Veronika on 24.03.2022.
//  
//

import UIKit
import SwiftUI

struct CellInfo {
    var cellType: MealsType
    var disclosureState: Bool
    var meals: Meals?
    
    init(initType: MealsType, initDisclosure: Bool, initMeal: Meals?) {
        cellType = initType
        disclosureState = initDisclosure
        meals = initMeal
    }
}

final class DietScreenViewController: UIViewController {
	private let output: DietScreenViewOutput
    
    var rowsInSections: [IndexPath:mealCells] = [:]
    
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
    
    private let dietTableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
    
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
        dietTableView.backgroundColor = .white
        dietTableView.style = .insetGrouped
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
    
    private func updateCells(at indexPath: IndexPath) {
        var mealType: MealsType
        switch rowsInSections[indexPath] {
        case .breakfast:
            mealType = .mealBreakfast
        case .lunch:
            mealType = .mealLunch
        case .dinner:
            mealType = .mealDinner
        default:
            return
        }

        if disclosureCells.contains(indexPath) {
            guard let numOfMealsInCell = (dietTableView.cellForRow(at:indexPath) as? DietCell)?.mealsList.count else { return }
            if numOfMealsInCell == 0 { return }
            dietTableView.beginUpdates()
            var mealCellsIndexes: [IndexPath] = []
            for mealNum in (indexPath.row + 1)...(indexPath.row + numOfMealsInCell) {
                let mealIndex = IndexPath(row: mealNum, section: indexPath.section)
                mealCellsIndexes.append(mealIndex)
                rowsInSections[mealIndex] = mealType
            }
            dietTableView.insertRows(at: mealCellsIndexes, with: .top)
            dietTableView.endUpdates()
        } else {
            dietTableView.beginUpdates()
            while rowsInSections.firstIndex(where: { $1 == mealType }) != nil {
                rowsInSections.remove(at: rowsInSections.firstIndex(where: {
                    dietTableView.deleteRows(at: [$0], with: .top)
                    return $1 == mealType
                })!)
            }
            dietTableView.endUpdates()
        }
        dietTableView.reloadSections([indexPath.section], with: .none)
    }
    
    private func disclosureCell(at indexPath: IndexPath) {
        guard let dietCell = dietTableView.cellForRow(at: indexPath) as? DietCell else {
            return
        }
        if disclosureCells.contains(indexPath) {
            dietCell.disclosure(true)
        } else {
            dietCell.disclosure(false)
        }
    }
}

extension DietScreenViewController: DietScreenViewInput {
    func setMealList(_ meals: [Meals], day: Int, mealtype: MealsType) {
        guard let cellForSetMealIndex = rowsInSections.first(where: {
            $1 == mealtype && $0.section == day - 1
        })?.key else {
            return
        }
        guard let cellForSetMeal = dietTableView.cellForRow(at: cellForSetMealIndex) as? DietCell else {
            return
        }
        cellForSetMeal.mealsList = meals
        updateCells(at: cellForSetMealIndex)
    }
}

extension DietScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellInformation = rowsInSections[indexPath] else {
            return tableView.dequeueReusableCell(withIdentifier: "Other", for: indexPath)
        }
        
        switch cellInformation.cellType {
        case .breakfast, .lunch, .dinner:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DietCell", for: indexPath) as? DietCell else {
                return tableView.dequeueReusableCell(withIdentifier: "Other", for: indexPath)
            }
            cellInformation.disclosureState ? cell.disclosure(true) : cell.disclosure(false)
            var cellText: String
            switch cellInformation.cellType {
            case .breakfast:
                cellText = "Завтрак"
            case .lunch
                cellText = "Обед"
            case .dinner
                cellText = "Обед"
            default:
                cellText = ""
            }
            cell.setText(cellText)
            return cell
        case .mealBreakfast, .mealLunch, .mealDinner:
            return tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath)
        case .none:
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
        return section == 0 ? 26 : 41
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        33
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var cellInformation = rowsInSections[indexPath] else { return }
        
        switch cellInformation.cellType {
        case .breakfast, .lunch, .dinner:
            
            
            disclosureCells.contains(indexPath) ? disclosureCells.removeAll(where: {$0 == indexPath}) : disclosureCells.append(indexPath)
            disclosureCell(at: indexPath)
            updateCells(at: indexPath)
            output.needMealList(day: indexPath.section + 1, mealtype: rowsInSections[indexPath] ?? .none)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsInSections.filter({$0.key.section == section}).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numOfSec = output.getNumOfDay()
        for currentSection in 0...numOfSec - 1 {
            rowsInSections[IndexPath(row: 0, section: currentSection)] = mealCells(initType: .breakfast, initDisclosure: false, initMeal: nil)
            rowsInSections[IndexPath(row: 1, section: currentSection)] = mealCells(initType: .lunch, initDisclosure: false, initMeal: nil)
            rowsInSections[IndexPath(row: 2, section: currentSection)] = mealCells(initType: .dinner, initDisclosure: false, initMeal: nil)
        }
        return numOfSec
    }
}
