//
//  TypographyViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 14/5/22.
//

import UIKit
import DanDesignSystem

class TypographyViewController: UIViewController {

    // ---------------------------------
    // MARK: - Outlets
    // ---------------------------------

    @IBOutlet weak var tableView: UITableView!

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private let data: [(section: String, fonts: [Typography.FontsWithSize], fontsNames: [String])] = [("Regular", [Typography.FontsWithSize.regularMini, Typography.FontsWithSize.regularSmall, Typography.FontsWithSize.regularMedium, Typography.FontsWithSize.regularLarge, Typography.FontsWithSize.regularExtraLarge, Typography.FontsWithSize.regularSuper], ["Regular Mini", "Regular Small", "Regular Medium", "Regular Large", "Regular Extra-Large", "Regular Super"]), ("Italic", [Typography.FontsWithSize.italicMini, Typography.FontsWithSize.italicSmall, Typography.FontsWithSize.italicMedium, Typography.FontsWithSize.italicLarge], ["Italic Mini", "Italic Small", "Italic Medium", "Italic Large"]), ("Bold", [Typography.FontsWithSize.boldMini, Typography.FontsWithSize.boldSmall, Typography.FontsWithSize.boldMedium, Typography.FontsWithSize.boldLarge], ["SemiBold Mini", "SemiBold Small", "SemiBold Medium", "SemiBold Large"])]

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {

        // Title
        title = "Typography"

        // Table
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
    }

}

// ---------------------------------
// MARK: - TypographyViewControllerViewDelegate
// ---------------------------------

extension TypographyViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].fonts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let font = data[indexPath.section].fonts[indexPath.row]
        let fontsNames = data[indexPath.section].fontsNames[indexPath.row]
        cell.textLabel?.dsConfigure(with: fontsNames, font: font, color: .black)
        cell.selectionStyle = .none
        return cell
    }

}
