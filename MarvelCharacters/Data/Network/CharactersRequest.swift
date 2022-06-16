//
//  CharactersRequest.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 31/5/22.
//

import Foundation

struct CharactersRequest: DataRequest {

    var limit, offset: Int?

    var url: String {
        let baseURL: String = AppConfiguration().apiBaseURL
        let path: String = "/v1/public/characters"
        return baseURL + path
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [String: String] {
        var parameters = getBaseParameters()
        parameters["limit"] = String(limit ?? 0)
        parameters["offset"] = String(offset ?? 0)
        return parameters
    }

    init(limit: Int, offset: Int) {
        self.limit = limit
        self.offset = offset
    }

    func decode(_ data: Data) throws -> ResponseCharacters {
        let decoder = JSONDecoder()
        let response = try decoder.decode(ResponseCharacters.self, from: data)
        return response
    }

}
