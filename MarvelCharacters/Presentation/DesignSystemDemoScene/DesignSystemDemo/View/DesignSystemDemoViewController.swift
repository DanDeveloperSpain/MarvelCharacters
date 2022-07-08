//
//  DesignSystemDemoViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/5/22.
//

import UIKit
import DanDesignSystem

class DesignSystemDemoViewController: UIViewController, CustomizableNavBar {

    // ---------------------------------
    // MARK: - Outlets
    // ---------------------------------
    @IBOutlet weak var tableView: UITableView!

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private let data: [(section: String, values: [String])] = [("Foundations", ["Typography", "Colors", "Borders", "Shadows"]), ("Components", ["Buttons", "Dialog", "Radio Button", "Checkbox"])]

    private var viewModel: DesignSystemDemoViewModel!

    // ---------------------------------
    // MARK: - Life Cycle
    // ---------------------------------

    static func create(viewModel: DesignSystemDemoViewModel) -> DesignSystemDemoViewController {
        let view = DesignSystemDemoViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    private func configureView() {
        setupNavigationBar(title: viewModel?.title, color: .dsBlack)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
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
                viewModel?.didSelectRadioButton()
            case 3:
                /// Checkbox
                viewModel?.didSelectCheckBox()
            default:
                break
            }

        default:
            break
        }
    }

}
