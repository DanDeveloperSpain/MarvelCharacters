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
    weak var finishDelegate: CoordinatorFinishDelegate? /// Last coordinator, no need to implement

    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = [] /// Last coordinator, no need to implement

    var type: CoordinatorType { .login }

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
        let loginVC: LoginViewController = .init()
        loginVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .login:
                self?.finish()
            case .createAccount:
                self?.goToCreateAccount()
            }
        }

        navigationController.pushViewController(loginVC, animated: true)
    }
}

extension LoginCoordinator {
    

    func goToCreateAccount() {
        let createAccountVC = CreateAccountViewController()
        createAccountVC.didSendEventClosure = { event in
            switch event {
            case .closeButton:
                createAccountVC.dismiss(animated: true)
            }

        }

        /// Modal
        createAccountVC.modalPresentationStyle = .overCurrentContext
        createAccountVC.modalTransitionStyle = .crossDissolve
        self.navigationController.present(createAccountVC, animated: true, completion: nil)
    }

}
