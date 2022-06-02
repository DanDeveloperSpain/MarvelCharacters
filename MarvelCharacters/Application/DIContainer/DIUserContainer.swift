//
//  DIUserContainer.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 20/4/22.
//

import UIKit
import Swinject

extension Container {

    static let sharedUserContainer: Container = {
        let container = Container()

        /// UserViewModel
        container.register(UserViewModel.self) { (_, coordinator: UserCoordinator) in
            return UserViewModel(coordinatorDelegate: coordinator)
        }

        /// UserViewController
        container.register(UserViewController.self) { (resolver, coordinator: UserCoordinator) in
            let userViewModel = resolver.resolve(UserViewModel.self, argument: coordinator) ?? UserViewModel(coordinatorDelegate: UserCoordinator(UINavigationController()))
            return UserViewController(viewModel: userViewModel)
        }

        return container

    }()
}
