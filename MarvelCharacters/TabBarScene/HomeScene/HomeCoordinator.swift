//
//  HomeCoordinator.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import UIKit

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

    let characterService = CharacterService()
    
    // ---------------------------------
    // MARK: - Coordinator
    // ---------------------------------

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showHomeViewController()
    }

    deinit {
        print("HomeCoordinator deinit")
    }

    func showHomeViewController() {
        let homeViewModel = HomeViewModel(coordinatorDelegate: self, characterService: characterService)
        let homeVC = HomeViewController(viewModel: homeViewModel)
        navigationController.pushViewController(homeVC, animated: true)
    }
    
}

// ---------------------------------
// MARK: - Navigation
// ---------------------------------

extension HomeCoordinator {
    
    func openCharacterDetail(character: Character){
        let characterDetailViewModel = CharacterDetailViewModel(coordinatorDelegate: self, character: character, characterService: characterService)
        let characterDetailVC = CharacterDetailViewController(viewModel: characterDetailViewModel)
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
