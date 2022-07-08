//
//  UserViewModelViewDelegate.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import Foundation

// ---------------------------------
// MARK: - Coordinator Delegates
// ---------------------------------

protocol UserViewModelCoordinatorDelegate: AnyObject {
    func  goToLogin()
}

final class UserViewModel {

    // ---------------------------------
    // MARK: - Delegates
    // ---------------------------------

    private weak var coordinatorDelegate: UserViewModelCoordinatorDelegate?

    // ---------------------------------
    // MARK: - Init
    // ---------------------------------

    /// Create a new LoginViewModel.
    /// - Parameters:
    ///   - coordinatorDelegate: The coordinator delegate
    init(coordinatorDelegate: UserViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    // ---------------------------------
    // MARK: - Events
    // ---------------------------------

    func didSelectCloseSesion() {
        coordinatorDelegate?.goToLogin()
    }

}
