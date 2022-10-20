//
//  ComicData.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import Foundation

struct ResponseComics: Decodable {
    let total: Int?
    let comics: [Comic]?
}

struct Comic: Decodable {
    let id: Int?
    let title: String?
    let imageUrl: String?
    let startDate: Date?
    var startYear: Int?
}
