//
//  DIAppConfigurationContainer.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 17/10/22.
//

import Foundation
import Swinject

extension Container {

    static let sharedAppConfigurationContainer: Container = {
        let container = Container()

        /// AppConfiguration
        container.register(AppConfiguration.self) { _ in
            AppConfiguration()
        }.inObjectScope(.container)

        return container

    }()
}
