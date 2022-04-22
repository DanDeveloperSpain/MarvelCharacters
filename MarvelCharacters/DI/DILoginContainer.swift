//
//  DILoginContainer.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 20/4/22.
//

import UIKit
import Swinject

extension Container {

    static let sharedLoginContainer: Container = {
        let container = Container()

        /// LoginViewModel
        container.register(LoginViewModel.self) { (_, coordinator: LoginCoordinator) in
            return LoginViewModel(coordinatorDelegate: coordinator)
        }

        /// LoginViewController
        container.register(LoginViewController.self) { (resolver, coordinator: LoginCoordinator) in
            let loginViewModel = resolver.resolve(LoginViewModel.self, argument: coordinator) ?? LoginViewModel(coordinatorDelegate: LoginCoordinator(UINavigationController()))
            return LoginViewController(viewModel: loginViewModel)
        }

        return container

    }()
}
