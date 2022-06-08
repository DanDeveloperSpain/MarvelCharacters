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
        var parameters = getParameters()
        parameters["limit"] = String(limit ?? 0)
        parameters["offset"] = String(offset ?? 0)
        return parameters
    }

    init(limit: Int, offset: Int, characterId: String) {
        self.limit = limit
        self.offset = offset
        self.characterId = characterId
    }

    func decode(_ data: Data) throws -> ResponseSeries {
        let decoder = JSONDecoder()
        let response = try decoder.decode(ResponseSeries.self, from: data)
        return response
    }

    // QUITAR DE AQUI
    func getParameters() -> [String: String] {
        let currentTimeStamp = Int(Date().timeIntervalSince1970)

        let has = Encryption.md5Hash("\(currentTimeStamp)" + Constants.ApiKeys.privateKey + Constants.ApiKeys.publicKey)

        let parameters: [String: String] = [
            "apikey" : Constants.ApiKeys.publicKey,
            "ts" : String(currentTimeStamp),
            "hash" :  has
        ]
        return parameters
    }

}
