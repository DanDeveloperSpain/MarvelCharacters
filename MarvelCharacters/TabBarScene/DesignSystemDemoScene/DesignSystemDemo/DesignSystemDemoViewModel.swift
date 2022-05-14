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

protocol DesignSystemDemoViewModelCoordinatorDelegate: AnyObject { // ---> DesignSystemDemoCoordinator
    func  goToTypography()
    func  goToColors()
}

// ---------------------------------
// MARK: - View Delegates
// ---------------------------------

protocol DesignSystemDemoViewModelViewDelegate: BaseControllerViewModelProtocol { // ---> DesignSystemDemoViewController
    // update specific item on screen
}

final class DesignSystemDemoViewModel: BaseViewModel {

    // ---------------------------------
    // MARK: - Delegates
    // ---------------------------------

    private weak var coordinatorDelegate: DesignSystemDemoViewModelCoordinatorDelegate?

    private weak var viewDelegate: DesignSystemDemoViewModelViewDelegate? {
        return self.baseView as? DesignSystemDemoViewModelViewDelegate
    }

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
    // MARK: - Life Cycle
    // ---------------------------------

    override func start() {
    }

    // ---------------------------------
    // MARK: - Events
    // ---------------------------------

    func didSelectTypography() {
        coordinatorDelegate?.goToTypography()
    }

    func didSelectColors() {
        coordinatorDelegate?.goToColors()
    }

}
