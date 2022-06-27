//
//  ComicsRequest.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/6/22.
//

import Foundation

struct ComicsRequest: DataRequest {

    var limit, offset: Int?
    var characterId: String?

    var path: String {
        let path: String = "/v1/public/characters/\(characterId ?? "")/comics"
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

    init(characterId: String, limit: Int, offset: Int) {
        self.characterId = characterId
        self.limit = limit
        self.offset = offset
    }

    func decode(_ data: Data) throws -> ResponseComics {
        let decoder = JSONDecoder()
        let response = try decoder.decode(ResponseComics.self, from: data)
        return response
    }

}
