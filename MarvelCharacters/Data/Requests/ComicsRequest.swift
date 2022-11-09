//
//  ComicsRequest.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/6/22.
//

import Foundation

// ------------------------------------------------
// MARK: - Request
// ------------------------------------------------

struct ComicsRequest: DataRequest {

    var characterId: String?
    var limit, offset: Int?

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

    func decode(_ data: Data) throws -> ComicDataWrapper {
        let decoder = JSONDecoder()
        let response = try decoder.decode(ComicDataWrapper.self, from: data)
        return response
    }

}

// ------------------------------------------------
// MARK: - Api entity
// ------------------------------------------------

struct ComicDataWrapper: Decodable {
    var code: Int?
    var data: ComicDataContainer
}

struct ComicDataContainer: Decodable {
    let offset, limit, total, count: Int?
    let results: [ComicData]?
}

struct ComicData: Decodable {
    let id: Int?
    let title: String?
    let thumbnail: ThumbnailData?
    let dates: [ComicDate]?
}

struct ComicDate: Decodable {
    let type, date: String?
}
