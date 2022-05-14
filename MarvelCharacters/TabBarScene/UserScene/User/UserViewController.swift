//
//  UserViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import UIKit
import DanDesignSystem

final class UserViewController: BaseViewController {

    // ---------------------------------
    // MARK: - Outlets
    // ---------------------------------

    @IBOutlet weak var closeSessionButton: UIButton!

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    /// Set the model of the view.
    private var viewModel: UserViewModel? {
        return (self.baseViewModel as? UserViewModel)
    }

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    override internal func setup() {
        viewModel?.setView(self)
        view.addGradient(colors: [.dsPrimaryPure, .dsSecondaryPure])
        closeSessionButton.configure(text: NSLocalizedString("Close session", comment: ""), font: .boldSmall, width: 150)
    }

    // ---------------------------------
    // MARK: - Buton Action's
    // ---------------------------------
    @IBAction func showLogoutButtonPressed(_ sender: UIButton) {
        viewModel?.didSelectCloseSesion()
    }

}

// ---------------------------------
// MARK: - UserViewModelViewDelegate
// ---------------------------------

extension UserViewController: UserViewModelViewDelegate {

    /// General notification when the view should be update.
    func updateScreen() {
    }

}
