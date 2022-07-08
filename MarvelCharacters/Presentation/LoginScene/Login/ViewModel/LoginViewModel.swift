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

final class LoginViewModel {

    // ---------------------------------
    // MARK: - Delegates
    // ---------------------------------

    private weak var coordinatorDelegate: LoginViewModelCoordinatorDelegate?

    // ------------------------------------------------
    // MARK: - ViewModel
    // ------------------------------------------------

    /// Create a new LoginViewModel.
    /// - Parameters:
    ///   - coordinatorDelegate: The coordinator delegate
    init(coordinatorDelegate: LoginViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    // ---------------------------------
    // MARK: - Events
    // ---------------------------------

    func showApp() {
        self.coordinatorDelegate?.goToApp()
    }

}
