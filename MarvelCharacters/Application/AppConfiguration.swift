//
//  AppConfiguration.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 31/5/22.
//

import Foundation

final class AppConfiguration {

    lazy var privateKey: String = {
        return ProcessInfo.processInfo.environment["PRIVATE_KEY"] ?? ""
    }()

    lazy var publicKey: String = {
        return ProcessInfo.processInfo.environment["PUBLIC_KEY"] ?? ""
    }()

    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}
