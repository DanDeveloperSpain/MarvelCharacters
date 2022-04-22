//
//  LoginViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 20/4/22.
//

import Foundation

// ---------------------------------
// MARK: - Coordinator Delegates
// ---------------------------------

protocol LoginViewModelCoordinatorDelegate: AnyObject {
    func goToApp()
}

// ---------------------------------
// MARK: - View Delegates
// ---------------------------------

protocol LoginViewModelViewDelegate: BaseControllerViewModelProtocol {
    // update specific item on screen
}

final class LoginViewModel: BaseViewModel {

    // ---------------------------------
    // MARK: - Delegates
    // ---------------------------------

    private weak var coordinatorDelegate: LoginViewModelCoordinatorDelegate?

    /// Set the view of the model.
    private weak var viewDelegate: LoginViewModelViewDelegate? {
        return self.baseView as? LoginViewModelViewDelegate
    }

    // ------------------------------------------------
    // MARK: - ViewModel
    // ------------------------------------------------

    /// Create a new LoginViewModel.
    /// - Parameters:
    ///   - coordinatorDelegate: The coordinator delegate
    init(coordinatorDelegate: LoginViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    /// First call of viewmodel lifecycle.
    override func start() {
    }

    // ---------------------------------
    // MARK: - Events
    // ---------------------------------
    func showApp() {
        self.coordinatorDelegate?.goToApp()
    }

}
