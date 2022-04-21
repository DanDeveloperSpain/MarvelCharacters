//
//  Constants.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 4/10/21.
//

import Foundation

public struct Constants {
    struct ApiKeys {
        static let privateKey = ProcessInfo.processInfo.environment["PRIVATE_KEY"] ?? ""
        static let publicKey =  ProcessInfo.processInfo.environment["PUBLIC_KEY"] ?? ""
    }
    
    struct Paths {
        static let baseUrl = "https://gateway.marvel.com"
        static let character = "/v1/public/characters"
        static func comics(characterId: Int) -> String { return "/v1/public/characters/\(characterId)/comics" }
        static func series(characterId: Int) -> String { return "/v1/public/characters/\(characterId)/series" }
    }
}
