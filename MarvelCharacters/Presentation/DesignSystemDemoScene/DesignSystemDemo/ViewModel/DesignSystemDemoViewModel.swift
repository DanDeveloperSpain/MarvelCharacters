//
//  DesignSystemDemoViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/5/22.
//

import Foundation

// ---------------------------------
// MARK: - Coordinator Delegates
// ---------------------------------

protocol DesignSystemDemoViewModelCoordinatorDelegate: AnyObject {
    /// Foundations
    func goToTypography()
    func goToColors()
    func goToBoders()
    func goToShadows()

    /// Components
    func goToButtons()
    func goToDialogs()
    func goToRadioButton()
    func goToCheckBox()
}

final class DesignSystemDemoViewModel {

    // ---------------------------------
    // MARK: - Delegates
    // ---------------------------------

    private weak var coordinatorDelegate: DesignSystemDemoViewModelCoordinatorDelegate?

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    var title: String {
        return NSLocalizedString("Dan Design System Demo", comment: "")
    }

    // ---------------------------------
    // MARK: - Init
    // ---------------------------------

    init(coordinatorDelegate: DesignSystemDemoViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    // ---------------------------------
    // MARK: - Events
    // ---------------------------------

    /// Components

    func didSelectTypography() {
        coordinatorDelegate?.goToTypography()
    }

    func didSelectColors() {
        coordinatorDelegate?.goToColors()
    }

    func didSelectBoders() {
        coordinatorDelegate?.goToBoders()
    }

    func didSelectShadows() {
        coordinatorDelegate?.goToShadows()
    }

    /// Foundations

    func didSelectButtons() {
        coordinatorDelegate?.goToButtons()
    }

    func didSelectDialogs() {
        coordinatorDelegate?.goToDialogs()
    }

    func didSelectRadioButton() {
        coordinatorDelegate?.goToRadioButton()
    }

    func didSelectCheckBox() {
        coordinatorDelegate?.goToCheckBox()
    }

}
