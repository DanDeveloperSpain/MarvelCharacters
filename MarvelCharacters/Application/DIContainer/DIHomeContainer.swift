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

        lazy var networkService: NetworkServiceProtocol = {
            let networkService = Container.sharedNetworkContainer.resolve(NetworkServiceProtocol.self)
            let appConfiguration = Container.sharedNetworkContainer.resolve(AppConfiguration.self) ?? AppConfiguration()
            let apiDataNetworkConfig = Container.sharedNetworkContainer.resolve(NetworkConfigurable.self) ?? ApiDataNetworkConfig(baseURL: appConfiguration.apiBaseURL, publicKey: appConfiguration.publicKey, privateKey: appConfiguration.privateKey)
            return networkService ?? DefaultNetworkService(apiDataNetworkConfig: apiDataNetworkConfig, logger: DefaultNetworkErrorLogger())
        }()

        lazy var homeCoordinator: HomeCoordinator = {
            HomeCoordinator(UINavigationController())
        }()
        lazy var charactersRepository: CharactersRepositoryProtocol = {
           return CharactersRepository(netWorkService: networkService)
        }()
        lazy var charactersUseCase: FetchCharactersUseCaseProtocol = {
           return FetchCharactersUseCase(charactersRepository: charactersRepository)
        }()

        /// NetworkService
        container.register(NetworkServiceProtocol.self) { _ in
            networkService
        }

        /// Repository
        container.register(CharactersRepositoryProtocol.self) { (resolver) in
            let networkService = resolver.resolve(NetworkServiceProtocol.self) ?? networkService
            return CharactersRepository(netWorkService: networkService)
        }

        /// UseCases
        container.register(FetchCharactersUseCaseProtocol.self) { (resolver) in
            let charactersRepository = resolver.resolve(CharactersRepositoryProtocol.self) ?? charactersRepository
            return FetchCharactersUseCase(charactersRepository: charactersRepository)
        }

        /// ViewModel
        container.register(CharactersListViewModel.self) { (resolver, coordinator: HomeCoordinator) in
            let charactersUseCase = resolver.resolve(FetchCharactersUseCaseProtocol.self) ?? charactersUseCase
            return CharactersListViewModel(coordinatorDelegate: coordinator, fetchCharactersUseCase: charactersUseCase)
        }

        /// ViewController
        container.register(CharactersListViewController.self) { (resolver, coordinator: HomeCoordinator) in
            let charactersListViewModel = resolver.resolve(CharactersListViewModel.self, argument: coordinator) ?? CharactersListViewModel(coordinatorDelegate: homeCoordinator, fetchCharactersUseCase: charactersUseCase)
            let charactersListViewController = CharactersListViewController.create(viewModel: charactersListViewModel)
            return charactersListViewController
        }

        return container

    }()

}
