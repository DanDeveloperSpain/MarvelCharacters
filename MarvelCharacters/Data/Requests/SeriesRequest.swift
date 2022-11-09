//
//  SeriesRequest.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/6/22.
//

import Foundation

// ------------------------------------------------
// MARK: - Request
// ------------------------------------------------

struct SeriesRequest: DataRequest {

    var characterId: String?
    var limit, offset: Int?

    var path: String {
        let path: String = "/v1/public/characters/\(characterId ?? "")/series"
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

    func decode(_ data: Data) throws -> SeriesDataWrapper {
        let decoder = JSONDecoder()
        let response = try decoder.decode(SeriesDataWrapper.self, from: data)
        return response
    }

}

// ------------------------------------------------
// MARK: - Api entity
// ------------------------------------------------

struct SeriesDataWrapper: Decodable {
    var code: Int?
    var data: SeriesDataContainer
}

struct SeriesDataContainer: Decodable {
    let offset, limit, total, count: Int?
    let results: [SerieData]?
}

struct SerieData: Decodable {
    let id: Int?
    let startYear: Int?
    let title: String?
    let thumbnail: ThumbnailData?
}
