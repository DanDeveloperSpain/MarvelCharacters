//
//  LoginViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import UIKit
import DanDesignSystem

class LoginViewController: UIViewController {

    // ------------------------------------------------
    // MARK: - Outlets
    // ------------------------------------------------

    @IBOutlet weak var loginButton: UIButton!

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    private var viewModel: LoginViewModel!

    // ---------------------------------
    // MARK: - Life Cycle
    // ---------------------------------

    static func create(viewModel: LoginViewModel) -> LoginViewController {
        let view = LoginViewController()
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

    /// Setup the view.
    private func configureView() {
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
