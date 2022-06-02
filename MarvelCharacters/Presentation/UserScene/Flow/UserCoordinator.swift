//
//  UserCoordinator.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import Foundation

import UIKit
import Swinject

// ---------------------------------
// MARK: UserCoordinatorProtocol
// ---------------------------------

protocol UserCoordinatorProtocol: Coordinator {
    func showUserViewController()
}

class UserCoordinator: UserCoordinatorProtocol {

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    weak var finishDelegate: CoordinatorFinishDelegate?

    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []

    var type: CoordinatorType { .tab }

    weak var parentCoordinator: TabCoordinator?

    // ---------------------------------
    // MARK: - Coordinator
    // ---------------------------------

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showUserViewController()
    }

    func showUserViewController() {
        let userVC = Container.sharedUserContainer.resolve(UserViewController.self, argument: self) ?? UserViewController(viewModel: UserViewModel(coordinatorDelegate: self))
        navigationController.pushViewController(userVC, animated: true)
    }

}

// ---------------------------------
// MARK: - Navigation
// ---------------------------------

extension UserCoordinator {
    func openLoginScreen() {
        self.parentCoordinator?.finish()
    }
}

// ---------------------------------
// MARK: - ViewModel Callback's
// ---------------------------------

extension UserCoordinator: UserViewModelCoordinatorDelegate {

    func goToLogin() {
        openLoginScreen()
    }
}
