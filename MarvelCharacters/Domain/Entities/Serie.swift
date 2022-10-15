//
//  SerieData.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 2/10/21.
//

import Foundation

struct ResponseSeries: Decodable {
    let offset, total: Int?
    let series: [Serie]?
}

struct Serie: Decodable {
    let id: Int?
    let startYear: Int?
    let title: String?
    let imageUrl: String?
}
