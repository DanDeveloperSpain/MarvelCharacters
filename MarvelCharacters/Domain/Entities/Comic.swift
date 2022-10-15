//
//  ComicData.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import Foundation

struct ResponseComics: Decodable {
    let offset, total: Int?
    let comics: [Comic]?
}

struct Comic: Decodable {
    let id: Int?
    let title: String?
    let imageUrl: String?
    let startDate: String?
}
