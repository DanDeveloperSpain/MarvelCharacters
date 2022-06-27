//
//  AppConfiguration.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 31/5/22.
//

import Foundation

final class AppConfiguration {

    lazy var privateKey: String = {
        return ProcessInfo.processInfo.environment["PRIVATE_KEY"] ?? "098a9998db7db386601f5068c30a8d68d2cf9342"
    }()

    lazy var publicKey: String = {
        return ProcessInfo.processInfo.environment["PUBLIC_KEY"] ?? "98c7937d8d052f6c636761eb20dff2d9"
    }()

    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}
