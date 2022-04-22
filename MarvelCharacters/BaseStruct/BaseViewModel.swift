//
//  BaseViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/10/21.
//

import Foundation

/// Protocol to implement by ViewControllers
protocol BaseViewModelProtocol {
    func start()
}

/// Base for the ViewModels with the basic structure.
class BaseViewModel: BaseViewModelProtocol {

    weak var baseView: BaseControllerViewModelProtocol?

    // ---------------------------------
    // MARK: - Init
    // ---------------------------------

    init() {
    }

    func setView(_ view: BaseControllerViewModelProtocol) {
        self.baseView = view
    }

    // ---------------------------------
    // MARK: - Life Cycle
    // ---------------------------------

    func start() {
        self.baseView?.updateScreen()
    }

}

// ---------------------------------
// MARK: - BaseControllerViewModelProtocol
// ---------------------------------

protocol BaseControllerViewModelProtocol: AnyObject {
    func updateScreen()
}
