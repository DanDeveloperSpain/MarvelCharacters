//
//  LoginViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import UIKit
import DanDesignSystem

class LoginViewController: BaseViewController {

    // ------------------------------------------------
    // MARK: - Outlets
    // ------------------------------------------------

    @IBOutlet weak var loginButton: UIButton!

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    /// Set the model of the view.
    private var viewModel: LoginViewModel? {
        return self.baseViewModel as? LoginViewModel
    }

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    /// Setup the view.
    override internal func setup() {
        viewModel?.setView(self)
        view.addGradient(colors: [.dsBluePure, .dsPurplePure])
        loginButton.dsConfigure(text: NSLocalizedString("Login", comment: ""), style: .secondary, state: .enabled)
    }

    // ------------------------------------------------
    // MARK: - Buton Action's
    // ------------------------------------------------

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        viewModel?.showApp()
    }

}

// --------------------------------------------------------------
// MARK: - LoginViewModelViewDelegate
// --------------------------------------------------------------
extension LoginViewController: LoginViewModelViewDelegate {

    /// General notification when the view should be update.
    func updateScreen() {
    }
}
