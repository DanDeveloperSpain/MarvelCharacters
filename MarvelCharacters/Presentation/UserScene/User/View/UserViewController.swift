//
//  UserViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import UIKit
import DanDesignSystem

final class UserViewController: UIViewController {

    // ---------------------------------
    // MARK: - Outlets
    // ---------------------------------

    @IBOutlet weak var closeSessionButton: UIButton!

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private var viewModel: UserViewModel!

    // ---------------------------------
    // MARK: - Life Cycle
    // ---------------------------------

    static func create(viewModel: UserViewModel) -> UserViewController {
        let view = UserViewController()
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
        view.addGradient(colors: [.dsPrimaryPure, .dsSecondaryPure])
        closeSessionButton.dsConfigure(text: NSLocalizedString("Close session", comment: ""), style: .secondary, state: .enabled, width: 150)
    }

    // ---------------------------------
    // MARK: - Buton Action's
    // ---------------------------------

    @IBAction func showLogoutButtonPressed(_ sender: UIButton) {
        viewModel?.didSelectCloseSesion()
    }

}
