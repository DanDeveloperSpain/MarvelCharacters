//
//  ColorsViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 14/5/22.
//

import UIKit
import DanDesignSystem

class ColorsViewController: UIViewController {

    // ---------------------------------
    // MARK: - Outlets
    // ---------------------------------

    @IBOutlet weak var tableView: UITableView!

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private let data: [(section: String, colors: [UIColor])] = [("Neutrals", [.dsBlack, .dsWhite]),
                                                                ("Primary", [.dsPrimaryPure, .dsPrimaryDark, .dsPrimaryLight]),
                                                                ("Secondary", [.dsSecondaryPure, .dsSecondaryDark, .dsSecondaryLight]),
                                                                ("Typography", [.dsGrayPure, .dsGrayDark, .dsGrayLight]),
                                                                ("Error", [.dsErrorPure, .dsErrorDark, .dsErrorLight]),
                                                                ("Waring", [.dsWaringPure, .dsWaringDark, .dsWaringLight]),
                                                                ("Info", [.dsInfoPure, .dsInfoDark, .dsInfoLight]),
                                                                ("Others-Blue", [.dsBluePure, .dsBlueDark, .dsBlueLight]),
                                                                ("Others-Purple", [.dsPurplePure, .dsPurpleDark, .dsPurpleLight])]

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        title = "Colors"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
    }

}

// ---------------------------------
// MARK: - UITableViewDataSource
// ---------------------------------

extension ColorsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].colors.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].section
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let color = data[indexPath.section].colors[indexPath.row]
        cell.textLabel?.dsConfigure(with: color.hex, font: .regularMedium, color: color == .dsBlack ? .dsWhite : .dsBlack)
        cell.backgroundColor = color
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        return cell
    }

}
