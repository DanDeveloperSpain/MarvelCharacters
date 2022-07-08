//
//  DICharacterDetailContainer.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 8/6/22.
//

import UIKit
import Swinject

extension Container {

    static let sharedCharacterDetailContainer: Container = {
        let container = Container()

        lazy var networkService: NetworkServiceProtocol = {
            let networkService = Container.sharedNetworkContainer.resolve(NetworkServiceProtocol.self)
            let appConfiguration = Container.sharedNetworkContainer.resolve(AppConfiguration.self) ?? AppConfiguration()
            let apiDataNetworkConfig = Container.sharedNetworkContainer.resolve(NetworkConfigurable.self) ?? ApiDataNetworkConfig(baseURL: appConfiguration.apiBaseURL, publicKey: appConfiguration.publicKey, privateKey: appConfiguration.privateKey)
            return networkService ?? DefaultNetworkService(apiDataNetworkConfig: apiDataNetworkConfig, logger: DefaultNetworkErrorLogger())
        }()

        lazy var comicsRepository: ComicsRepositoryProtocol = {
           return ComicsRepository(netWorkService: networkService)
        }()
        lazy var comicsUseCase: FetchComicsUseCaseProtocol = {
           return FetchComicsUseCase(comicsRepository: comicsRepository)
        }()

        lazy var seriesRepository: SeriesRepositoryProtocol = {
           return SeriesRepository(netWorkService: networkService)
        }()
        lazy var seriesUseCase: FetchSeriesUseCaseProtocol = {
           return FetchSeriesUseCase(seriesRepository: seriesRepository)
        }()

        lazy var homeCoordinator: HomeCoordinator = {
            HomeCoordinator(UINavigationController())
        }()
        lazy var characterDetail: Character = {
            Character(id: 0, name: "", description: "", thumbnail: Thumbnail(path: "", typeExtension: ""))
        }()

        /// NetworkService
        container.register(NetworkServiceProtocol.self) { _ in
            networkService
        }

        /// Comic Repository
        container.register(ComicsRepositoryProtocol.self) { (resolver) in
            let networkService = resolver.resolve(NetworkServiceProtocol.self) ?? networkService
            return ComicsRepository(netWorkService: networkService)
        }

        /// Serie Repository
        container.register(SeriesRepositoryProtocol.self) { (resolver) in
            let networkService = resolver.resolve(NetworkServiceProtocol.self) ?? networkService
            return SeriesRepository(netWorkService: networkService)
        }

        /// FetchComics UseCase
        container.register(FetchComicsUseCaseProtocol.self) { (resolver) in
            let comicsRepository = resolver.resolve(ComicsRepositoryProtocol.self) ?? comicsRepository
            return FetchComicsUseCase(comicsRepository: comicsRepository)
        }

        /// FetchComics UseCase
        container.register(FetchSeriesUseCaseProtocol.self) { (resolver) in
            let seriesRepository = resolver.resolve(SeriesRepositoryProtocol.self) ?? seriesRepository
            return FetchSeriesUseCase(seriesRepository: seriesRepository)
        }

        /// ViewModel
        container.register(CharacterDetailViewModel.self) { (resolver, coordinator: HomeCoordinator, character: Character) in
            let comicsUseCase = resolver.resolve(FetchComicsUseCaseProtocol.self) ?? comicsUseCase
            let seriesUseCase = resolver.resolve(FetchSeriesUseCaseProtocol.self) ?? seriesUseCase
            return CharacterDetailViewModel(coordinatorDelegate: coordinator, fetchComicsUseCase: comicsUseCase, fetchSeriesUseCase: seriesUseCase, character: character)
        }

        /// ViewController
        container.register(CharacterDetailViewController.self) { (resolver, coordinator: HomeCoordinator, character: Character) in
            let charactersDetailViewModel = resolver.resolve(CharacterDetailViewModel.self, arguments: coordinator, character) ?? CharacterDetailViewModel(coordinatorDelegate: homeCoordinator, fetchComicsUseCase: comicsUseCase, fetchSeriesUseCase: seriesUseCase, character: characterDetail)
            let characterDetailViewController = CharacterDetailViewController.create(viewModel: charactersDetailViewModel)
            return characterDetailViewController
        }

        return container
    }()
}
