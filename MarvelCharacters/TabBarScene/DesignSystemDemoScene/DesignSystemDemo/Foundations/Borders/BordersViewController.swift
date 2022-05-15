//
//  BordersViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 14/5/22.
//

import UIKit
import DanDesignSystem

class BordersViewController: UIViewController {

    // ---------------------------------
    // MARK: - Outlets
    // ---------------------------------

    @IBOutlet weak var tableView: UITableView!

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private let dataRadius: [Radius] = [.small, .medium, .large, .full]
    private let dataBorder: [Border] = [.small, .medium, .small, .small]

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        title = "Borders"

        tableView.register(UINib(nibName: BorderCell.kCellId, bundle: nil), forCellReuseIdentifier: BorderCell.kCellId)
        tableView.rowHeight = 200
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
    }

}

// ---------------------------------
// MARK: - UITableViewDataSource
// ---------------------------------
extension BordersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataRadius.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BorderCell.kCellId, for: indexPath) as? BorderCell
        let radius = dataRadius[indexPath.row]
        let border = dataBorder[indexPath.row]

        cell?.fill(borderName: "Radius: " + radius.radiusName + " - Border: " + border.borderName, borderRadiusPx: radius == .full ? "maximun radius" : "\(radius.rawValue)" + "px")
        cell?.borderView.boderRadius(radius: radius, border: border)

        return cell ?? UITableViewCell()
    }

}
