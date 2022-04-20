//
//  LoginCoordinator.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import UIKit

protocol LoginCoordinatorProtocol: Coordinator {
    func showLoginViewController()
}

class LoginCoordinator: LoginCoordinatorProtocol {
    
    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------
    
    weak var finishDelegate: CoordinatorFinishDelegate? /// Last coordinator, no need to implement

    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = [] /// Last coordinator, no need to implement

    var type: CoordinatorType { .login }
    
    // ---------------------------------
    // MARK: - Coordinator
    // ---------------------------------

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = false
    }

    func start() {
        showLoginViewController()
    }

    deinit {
        print("LoginCoordinator deinit")
    }

    func showLoginViewController() {
        let LoginViewModel = LoginViewModel(coordinatorDelegate: self)
        let loginVC = LoginViewController(viewModel: LoginViewModel)
        navigationController.pushViewController(loginVC, animated: true)
    }
}

// ---------------------------------
// MARK: - ViewModel Callback's
// ---------------------------------

extension LoginCoordinator: LoginViewModelCoordinatorDelegate {
    func goToApp() {
        self.finish()
    }
    
}
