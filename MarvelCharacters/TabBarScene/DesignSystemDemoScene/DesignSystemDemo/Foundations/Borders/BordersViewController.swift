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

    private let data: [Border] = [.small, .medium, .large, .full]

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
        tableView.dataSource = self
    }

}

// ---------------------------------
// MARK: - UITableViewDataSource
// ---------------------------------
extension BordersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BorderCell.kCellId, for: indexPath) as? BorderCell
        let border = data[indexPath.row]

        cell?.fill(borderName: border.borderName, borderRadiusPx: border == .full ? "maximun radius" : "\(border.rawValue)" + "px")
        cell?.borderView.boder(border: border)

        return cell ?? UITableViewCell()
    }

}
