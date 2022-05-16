//
//  ButtonsViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 15/5/22.
//

import UIKit
import DanDesignSystem

class ButtonsViewController: UIViewController {

    // ---------------------------------
    // MARK: - Outlets
    // ---------------------------------

    @IBOutlet weak var tableView: UITableView!

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private let data: (buttonsType: [TypeButton], buttonsState: [StateButton]) = ([.primary, .secondary], [.enabled, .disabled])

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        title = "Buttons"

        tableView.register(UINib(nibName: ButtonCell.kCellId, bundle: nil), forCellReuseIdentifier: ButtonCell.kCellId)
        tableView.rowHeight = 125
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

}

// ---------------------------------
// MARK: - UITableViewDataSource
// ---------------------------------

extension ButtonsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.buttonsType.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.buttonsType.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data.buttonsType[section].name
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.kCellId, for: indexPath) as? ButtonCell
        let buttonsType = data.buttonsType[indexPath.section]
        let buttonsState = data.buttonsState[indexPath.row]

        cell?.fill(buttonsStateName: buttonsState.name)
        cell?.textButton.dsConfigure(text: "Button", style: buttonsType, state: buttonsState)
        cell?.iconButton.dsConfigure(image: DSImage(named: .icon_mail), style: buttonsType, state: buttonsState, width: 40)

        cell?.selectionStyle = .none

        return cell ?? UITableViewCell()
    }
}
