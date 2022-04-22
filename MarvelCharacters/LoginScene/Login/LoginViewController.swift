//
//  LoginViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import UIKit

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

    // ------------------------------------------------
    // MARK: - Life Cycle
    // ------------------------------------------------

    /// IMPORTANT: setup will always run first
    /// viewDidLoad
    /// viewWillAppear
    /// viewDidAppear
    /// viewDidDisappear

    deinit {
        print("LoginViewController deinit")
    }

     override func viewDidLoad() {
         super.viewDidLoad()
         print("___ viewDidLoad LoginViewModel")
    }

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    /// Setup the view.
    override internal func setup() {
        viewModel?.setView(self)
        print("___ start LoginViewController")
        view.addGradient(colors: [.blueColor, .purpleColor])
        loginButton.configure(text: NSLocalizedString("Login", comment: ""), font: .boldSmall)
    }

    // ------------------------------------------------
    // MARK: - Buton Action's
    // ------------------------------------------------

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        viewModel?.showApp()

    }

}

// --------------------------------------------------------------
// MARK: - HomeViewModelViewDelegate
// --------------------------------------------------------------
extension LoginViewController: LoginViewModelViewDelegate {
    func updateScreen() {
        print("updateScreen")
    }
}
