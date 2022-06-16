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

        lazy var networkService: NetworkServiceProtocol = {
           return DefaultNetworkService()
        }()

        /// NetworkService
        container.register(NetworkServiceProtocol.self) { _ in
            networkService
        }

        return container

    }()

}
