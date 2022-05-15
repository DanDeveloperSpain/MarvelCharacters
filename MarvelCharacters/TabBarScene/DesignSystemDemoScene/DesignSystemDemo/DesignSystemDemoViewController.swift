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

    private let data: [(section: String, values: [String])] = [("Foundations", ["Typography", "Colors", "Borders", "Shadows"]), ("Components", ["Buttons", "Dialog", "Radio Button", "Checkbox"])]

    /// Set the model of the view.
    private var viewModel: DesignSystemDemoViewModel? {
        return (self.baseViewModel as? DesignSystemDemoViewModel)
    }

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    override internal func setup() {
        viewModel?.setView(self)
        setupNavigationBar(title: viewModel?.title, color: .dsBlack)

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
                /// Typography
                viewModel?.didSelectTypography()
            case 1:
                /// Colors
                viewModel?.didSelectColors()
            case 2:
                /// Borders
                viewModel?.didSelectBoders()
            case 3:
                /// Shadows
                viewModel?.didSelectShadows()
            default:
                break
            }

        case 1:
            switch indexPath.row {
            case 0:
                /// Buttons
                viewModel?.didSelectButtons()
            case 1:
                /// Dialogs
                viewModel?.didSelectDialogs()
            case 2:
                /// Radio Button
                print("Radio Button")
            case 3:
                /// Checkbox
                print("Checkbox")
            default:
                break
            }

        default:
            break
        }
    }

}
