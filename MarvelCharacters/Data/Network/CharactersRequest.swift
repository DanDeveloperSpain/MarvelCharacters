//
//  CharactersRequest.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 31/5/22.
//

import Foundation

// ------------------------------------------------
// MARK: - Request
// ------------------------------------------------

struct CharactersRequest: DataRequest {

    var limit, offset: Int?

    var path: String {
        let path: String = "/v1/public/characters"
        return path
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [String: String] {
        var parameters: [String: String] = [:]
        parameters["limit"] = String(limit ?? 0)
        parameters["offset"] = String(offset ?? 0)
        return parameters
    }

    func decode(_ data: Data) throws -> CharacterDataWrapper {
        let decoder = JSONDecoder()
        let response = try decoder.decode(CharacterDataWrapper.self, from: data)
        return response
    }

}

// ------------------------------------------------
// MARK: - Api entity
// ------------------------------------------------

struct CharacterDataWrapper: Decodable {
    var code: Int?
    var data: CharacterDataContainer
}

struct CharacterDataContainer: Decodable {
    let offset, limit, total, count: Int?
    let results: [CharacterData]?
}

struct CharacterData: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: ThumbnailData?
}

struct ThumbnailData: Decodable {
    let path, typeExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case typeExtension = "extension"
    }

}
