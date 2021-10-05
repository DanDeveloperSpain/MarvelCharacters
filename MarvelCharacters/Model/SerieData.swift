//
//  SerieData.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 2/10/21.
//

import Foundation

struct ResponseSeries: Decodable {
    var code: Int?
    var data: ResponseSeriesData
}

struct ResponseSeriesData: Decodable {
    let offset, limit, total, count: Int?
    let all: [Serie]?

    enum CodingKeys: String, CodingKey {
        case offset, limit, total, count
        case all = "results"
    }
}

struct Serie: Decodable {
    let id: Int?
    let startYear: Int?
    let title: String?
    let thumbnail: Thumbnail?
}
