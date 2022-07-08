//
//  DSDemoCoordinator.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/5/22.
//

import UIKit
import Swinject

// ---------------------------------
// MARK: DesignSystemDemoCoordinatorProtocol
// ---------------------------------

protocol DesignSystemDemoCoordinatorProtocol: Coordinator {
    func showDesignSystemDemoViewController()
}

class DesignSystemDemoCoordinator: DesignSystemDemoCoordinatorProtocol {

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
        showDesignSystemDemoViewController()
    }

    func showDesignSystemDemoViewController() {
        let DSDemoVC = Container.sharedDesignSystemDemoContainer.resolve(DesignSystemDemoViewController.self, argument: self) ?? DesignSystemDemoViewController()
        navigationController.pushViewController(DSDemoVC, animated: true)
    }

}

// ---------------------------------
// MARK: - Navigation
// ---------------------------------

extension DesignSystemDemoCoordinator {

    // Foundations

    func openTypographyScreen() {
        navigationController.pushViewController(TypographyViewController(), animated: true)
    }

    func openColorsScreen() {
        navigationController.pushViewController(ColorsViewController(), animated: true)
    }

    func openBordersScreen() {
        navigationController.pushViewController(BordersViewController(), animated: true)
    }

    func openShadowsScreen() {
        navigationController.pushViewController(ShadowsViewController(), animated: true)
    }

    // Components

    func openButtonsScreen() {
        navigationController.pushViewController(ButtonsViewController(), animated: true)
    }

    func openDialogsScreen() {
        navigationController.pushViewController(DialogsViewController(), animated: true)
    }

    func openRadioButtonScreen() {
        navigationController.pushViewController(RadioButtonViewController(), animated: true)
    }

    func openCheckboxScreen() {
        navigationController.pushViewController(CheckboxViewController(), animated: true)
    }
}

// ---------------------------------
// MARK: - ViewModel Callback's
// ---------------------------------

extension DesignSystemDemoCoordinator: DesignSystemDemoViewModelCoordinatorDelegate {

    // Foundations

    func goToTypography() {
        openTypographyScreen()
    }

    func goToColors() {
        openColorsScreen()
    }

    func goToBoders() {
        openBordersScreen()
    }

    func goToShadows() {
        openShadowsScreen()
    }

    // Components

    func goToButtons() {
        openButtonsScreen()
    }

    func goToDialogs() {
        openDialogsScreen()
    }

    func goToRadioButton() {
        openRadioButtonScreen()
    }

    func goToCheckBox() {
        openCheckboxScreen()
    }

}
