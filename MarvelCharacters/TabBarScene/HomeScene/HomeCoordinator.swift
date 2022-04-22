//
//  HomeCoordinator.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import UIKit
import Swinject

// ---------------------------------
// MARK: HomeCoordinatorProtocol
// ---------------------------------

protocol HomeCoordinatorProtocol: Coordinator {
    func showHomeViewController()
}

// ---------------------------------
// MARK: HomeCoordinator
// ---------------------------------

class HomeCoordinator: HomeCoordinatorProtocol {

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
        showHomeViewController()
    }

    func showHomeViewController() {
        let homeVC = Container.sharedHomeContainer.resolve(HomeViewController.self, argument: self) ?? HomeViewController(viewModel: HomeViewModel(coordinatorDelegate: self, characterService: CharacterService()))
        navigationController.pushViewController(homeVC, animated: true)
    }

}

// ---------------------------------
// MARK: - Navigation
// ---------------------------------

extension HomeCoordinator {

    func openCharacterDetail(character: Character) {
        let characterDetailVC = Container.sharedHomeContainer.resolve(CharacterDetailViewController.self, arguments: character, self) ?? CharacterDetailViewController(viewModel: CharacterDetailViewModel(coordinatorDelegate: self, character: character, characterService: CharacterService()))
        navigationController.pushViewController(characterDetailVC, animated: true)
    }
}

// ---------------------------------
// MARK: - ViewModel Callback's
// ---------------------------------

extension HomeCoordinator: HomeViewModelCoordinatorDelegate {

    func goToCharacterDetail(character: Character) {
        openCharacterDetail(character: character)
    }
}

extension HomeCoordinator: CharacterDetailViewModelCoordinatorDelegate {

}
