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
    func showCharactersListViewController()
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
        showCharactersListViewController()
    }

    func showCharactersListViewController() {
        let charactersListVC = Container.sharedHomeContainer.resolve(CharactersListViewController.self, argument: self) ?? CharactersListViewController()
        navigationController.pushViewController(charactersListVC, animated: true)
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

extension HomeCoordinator: CharactersListViewModelCoordinatorDelegate {

    func goToCharacterDetail(character: Character) {
        openCharacterDetail(character: character)
    }
}

extension HomeCoordinator: CharacterDetailViewModelCoordinatorDelegate {

}
