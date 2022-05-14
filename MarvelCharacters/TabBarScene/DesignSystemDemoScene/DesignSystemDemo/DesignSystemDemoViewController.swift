//
//  DesignSystemDemoViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/5/22.
//

import UIKit
import DanDesignSystem

class DesignSystemDemoViewController: BaseViewController {

    // ---------------------------------
    // MARK: - Outlets
    // ---------------------------------
    @IBOutlet weak var tableView: UITableView!

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private let data: [(section: String, values: [String])] = [("Foundations", ["Colors", "Typography", "Borders", "Shadows"]), ("Components", ["Buttons", "Cards", "Chips", "Banners", "Recommendations", "Radio Button", "Date Selector", "Dialog", "Checkbox"])]

    /// Set the model of the view.
    private var viewModel: DesignSystemDemoViewModel? {
        return (self.baseViewModel as? DesignSystemDemoViewModel)
    }

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    override internal func setup() {
        viewModel?.setView(self)
        self.setupNavigationBar(title: viewModel?.title, color: .dsBlack)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }

}

// ---------------------------------
// MARK: - DesignSystemDemoViewModelViewDelegate
// ---------------------------------

extension DesignSystemDemoViewController: DesignSystemDemoViewModelViewDelegate {

    /// General notification when the view should be update.
    func updateScreen() {
    }

}

// ---------------------------------
// MARK: - DesignSystemDemoTableViewDelegate
// ---------------------------------
extension DesignSystemDemoViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].values.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].section
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.dsConfigure(with: data[indexPath.section].values[indexPath.row], font: .regularMedium, color: .dsGrayDark)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.section {

        case 0:
            switch indexPath.row {
            case 0:
                // Colors
                viewModel?.didSelectColors()
            case 1:
                // Typography
                viewModel?.didSelectTypography()
            default:
                break
            }

        case 1:
            switch indexPath.row {
            case 0:
                // Buttons
                print("Buttons")
                // navigationController?.pushViewController(ButtonsViewController(), animated: true)
            case 1:
                // Cards
                print("Cards")
                // navigationController?.pushViewController(CardsViewController(), animated: true)
            default:
                break
            }

        default:
            break
        }
    }

}
