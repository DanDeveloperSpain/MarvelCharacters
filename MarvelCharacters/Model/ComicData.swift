//
//  ComicData.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import Foundation

struct ResponseComics: Decodable {
    var code: Int?
    var data: ResponseComicsData
}

struct ResponseComicsData: Decodable {
    let offset, limit, total, count: Int?
    let all: [Comic]?

    enum CodingKeys: String, CodingKey {
        case offset, limit, total, count
        case all = "results"
    }
}

struct Comic: Decodable {
    let id: Int?
    let title: String?
    let thumbnail: Thumbnail?
    let dates : [DateMarvel]?
    
    var year : String? {
        if let onsaleDate = dates?.filter({$0.type == "onsaleDate"}).first {
            return Util().stringDateToShortDate(dateString: onsaleDate.date ?? "")
        } else {
            return ""
        }
    }
}
