//
//  ShadowsViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 14/5/22.
//

import UIKit
import DanDesignSystem

class ShadowsViewController: UIViewController {

    // ---------------------------------
    // MARK: - Outlets
    // ---------------------------------

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private let data: [Shadow] = [.base, .flat, .small, .medium, .large, .transparent]

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        // Title
        title = "Shadows"

        // Table
        tableView.register(UINib(nibName: ShadowCell.kCellId, bundle: nil), forCellReuseIdentifier: ShadowCell.kCellId)
        tableView.rowHeight = 200
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
    }

}

// ---------------------------------
// MARK: - UITableViewDataSource
// ---------------------------------

extension ShadowsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShadowCell.kCellId, for: indexPath) as? ShadowCell
        let shadow = data[indexPath.row]

        cell?.fill(shadowName: shadow.shadowName, backgroundColor: UIColor.systemBackground)
        cell?.shadowView.shadow(shadow: shadow, color: .dsGrayLight)
        cell?.shadowView.layer.cornerRadius = Border.small.rawValue

        return cell ?? UITableViewCell()
    }

}
