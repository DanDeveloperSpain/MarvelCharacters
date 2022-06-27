//
//  DINetworkContainer.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/6/22.
//

import Foundation
import Swinject

extension Container {

    static let sharedNetworkContainer: Container = {
        let container = Container()

        let appConfiguration = AppConfiguration()
        let logger = DefaultNetworkErrorLogger()

        lazy var apiDataNetworkConfig: NetworkConfigurable = {
            ApiDataNetworkConfig(baseURL: appConfiguration.apiBaseURL, publicKey: appConfiguration.publicKey, privateKey: appConfiguration.privateKey)
        }()

        lazy var networkService: NetworkServiceProtocol = {
            return DefaultNetworkService(apiDataNetworkConfig: apiDataNetworkConfig, logger: logger)
        }()

        /// AppConfiguration
        container.register(AppConfiguration.self) { _ in
            appConfiguration
        }

        /// ApiDataNetworkConfig
        container.register(NetworkConfigurable.self) { _ in
            apiDataNetworkConfig
        }

        /// NetworkService
        container.register(NetworkServiceProtocol.self) { _ in
            networkService
        }

        return container

    }()

}
