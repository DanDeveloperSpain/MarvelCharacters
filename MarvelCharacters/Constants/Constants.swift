//
//  Constants.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 4/10/21.
//

import Foundation

public struct Constants {
    struct ApiKeys {
        static let privateKey = "098a9998db7db386601f5068c30a8d68d2cf9342" //ProcessInfo.processInfo.environment["PRIVATE_KEY"] ?? ""
        static let publicKey =  "98c7937d8d052f6c636761eb20dff2d9" //ProcessInfo.processInfo.environment["PUBLIC_KEY"] ?? ""
    }
    
    struct Paths {
        static let baseUrl = "https://gateway.marvel.com"
        static let character = "/v1/public/characters"
        static func comics(characterId: Int) -> String { return "/v1/public/characters/\(characterId)/comics" }
        static func series(characterId: Int) -> String { return "/v1/public/characters/\(characterId)/series" }
    }
}
