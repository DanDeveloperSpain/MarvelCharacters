//
//  SeriesRequest.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/6/22.
//

import Foundation

struct SeriesRequest: DataRequest {

    var limit, offset: Int?
    var characterId: String?

    var url: String {
        let baseURL: String = AppConfiguration().apiBaseURL
        let path: String = "/v1/public/characters/\(characterId ?? "")/series"
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

    init(characterId: String, limit: Int, offset: Int) {
        self.characterId = characterId
        self.limit = limit
        self.offset = offset
    }

    func decode(_ data: Data) throws -> ResponseSeries {
        let decoder = JSONDecoder()
        let response = try decoder.decode(ResponseSeries.self, from: data)
        return response
    }

}
