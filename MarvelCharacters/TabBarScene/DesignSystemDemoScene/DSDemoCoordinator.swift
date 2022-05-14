//
//  DSDemoCoordinator.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/5/22.
//

import UIKit
import Swinject

// ---------------------------------
// MARK: DSDemoCoordinatorProtocol
// ---------------------------------

protocol DSDemoCoordinatorProtocol: Coordinator {
    func showDSDemoViewController()
}

class DSDemoCoordinator: DSDemoCoordinatorProtocol {

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
        showDSDemoViewController()
    }

    func showDSDemoViewController() {
        let DSDemoVC = Container.sharedDesignSystemDemoContainer.resolve(DesignSystemDemoViewController.self, argument: self) ?? DesignSystemDemoViewController(viewModel: DesignSystemDemoViewModel(coordinatorDelegate: self))
        navigationController.pushViewController(DSDemoVC, animated: true)
    }

}

// ---------------------------------
// MARK: - Navigation
// ---------------------------------

extension DSDemoCoordinator {
    func openColorsScreen() {
        navigationController.pushViewController(ColorsViewController(), animated: true)
    }

    func openTypographyScreen() {
        navigationController.pushViewController(TypographyViewController(), animated: true)
    }
}

// ---------------------------------
// MARK: - ViewModel Callback's
// ---------------------------------

extension DSDemoCoordinator: DesignSystemDemoViewModelCoordinatorDelegate {
    func goToTypography() {
        openTypographyScreen()
    }

    func goToColors() {
        openColorsScreen()
    }

}
