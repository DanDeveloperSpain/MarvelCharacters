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

protocol UserViewModelCoordinatorDelegate: AnyObject { // ---> UserCoordinator
    func  goToLogin()
}

// ---------------------------------
// MARK: - View Delegates
// ---------------------------------

protocol UserViewModelViewDelegate: BaseControllerViewModelProtocol { // ---> UserViewController
    // update specific item on screen
}

final class UserViewModel: BaseViewModel {

    // ---------------------------------
    // MARK: - Delegates
    // ---------------------------------

    private weak var coordinatorDelegate: UserViewModelCoordinatorDelegate?

    private weak var viewDelegate: UserViewModelViewDelegate? {
        return self.baseView as? UserViewModelViewDelegate
    }

    // ---------------------------------
    // MARK: - Init
    // ---------------------------------

    init(coordinatorDelegate: UserViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    // ---------------------------------
    // MARK: - Life Cycle
    // ---------------------------------

    override func start() {
        getDataUser()
    }

    // ---------------------------------
    // MARK: - Network
    // ---------------------------------

    func getDataUser() {
        viewDelegate?.updateScreen()
    }

    // ---------------------------------
    // MARK: - Events
    // ---------------------------------

    func didSelectCloseSesion() {
        coordinatorDelegate?.goToLogin()
    }

}
