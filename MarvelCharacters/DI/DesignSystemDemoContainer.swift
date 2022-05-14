//
//  DesignSystemDemoContainer.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/5/22.
//

import UIKit
import Swinject

extension Container {

    static let sharedDesignSystemDemoContainer: Container = {
        let container = Container()

        /// DesignSystemDemoViewModel
        container.register(DesignSystemDemoViewModel.self) { (_, coordinator: DSDemoCoordinator) in
            return DesignSystemDemoViewModel(coordinatorDelegate: coordinator)
        }

        /// DesignSystemDemoViewController
        container.register(DesignSystemDemoViewController.self) { (resolver, coordinator: DSDemoCoordinator) in
            let userViewModel = resolver.resolve(DesignSystemDemoViewModel.self, argument: coordinator) ?? DesignSystemDemoViewModel(coordinatorDelegate: DSDemoCoordinator(UINavigationController()))
            return DesignSystemDemoViewController(viewModel: userViewModel)
        }

        return container

    }()
}
