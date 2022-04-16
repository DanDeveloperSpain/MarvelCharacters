//
//  UserViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import UIKit

final class UserViewController: BaseViewController {

    // ---------------------------------
    // MARK: - Outlets
    // ---------------------------------

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private var viewModel: UserViewModel? {
        return (self.baseViewModel as? UserViewModel)
    }

    // ---------------------------------
    // MARK: - Life Cycle
    // ---------------------------------

    // IMPORTANT: setup will always run first
    // viewDidLoad
    // viewWillAppear
    // viewDidAppear
    // viewDidDisappear

    deinit {
        print("UserViewController deinit")
    }

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    override internal func setup() {
        viewModel?.setView(self)
        print("___ setup UserViewController")
    }

    // ---------------------------------
    // MARK: - Buton Action's
    // ---------------------------------

    // ---------------------------------
    // MARK: - Private methods
    // ---------------------------------

}

// ---------------------------------
// MARK: - UserViewModelViewDelegate
// ---------------------------------

extension UserViewController: UserViewModelViewDelegate {

    func updateScreen() {
        print("updateScreen User!!!")
    }

}
