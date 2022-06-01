//
//  DIContainer.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 20/4/22.
//

import UIKit
import Swinject

extension Container {

    static let sharedHomeContainer: Container = {
        let container = Container()

        let characterService = CharacterService()
        let homeCoordinator = HomeCoordinator(UINavigationController())
        let character = Character(id: 0, name: "", description: "", thumbnail: Thumbnail(path: "", typeExtension: ""))

        /// CharacterService
        container.register(CharacterServiceProtocol.self) { _ in
            characterService
        }

        /// CharacterListViewModel
        container.register(CharactersListViewModel.self) { (resolver, coordinator: HomeCoordinator) in
            let service = resolver.resolve(CharacterServiceProtocol.self) ?? characterService
            return CharactersListViewModel(coordinatorDelegate: coordinator, characterService: service)
        }

        /// CharacterListViewController
        container.register(CharactersListViewController.self) { (resolver, coordinator: HomeCoordinator) in
            let charactersListViewModel = resolver.resolve(CharactersListViewModel.self, argument: coordinator) ?? CharactersListViewModel(coordinatorDelegate: homeCoordinator, characterService: characterService)
            return CharactersListViewController(viewModel: charactersListViewModel)
        }

        /// CharacterDetailViewModel
        container.register(CharacterDetailViewModel.self) { (resolver, character: Character, coordinator: HomeCoordinator) in
            let service = resolver.resolve(CharacterServiceProtocol.self) ?? characterService
            return CharacterDetailViewModel(coordinatorDelegate: coordinator, character: character, characterService: service)
        }

        /// CharacterDetailViewController
        container.register(CharacterDetailViewController.self) {(resolver, character: Character, coordinator: HomeCoordinator) in
            let characterDetailViewModel = resolver.resolve(CharacterDetailViewModel.self, arguments: character, coordinator) ?? CharacterDetailViewModel(coordinatorDelegate: homeCoordinator, character: character, characterService: characterService)
            return CharacterDetailViewController(viewModel: characterDetailViewModel)
        }

        return container

    }()

}
