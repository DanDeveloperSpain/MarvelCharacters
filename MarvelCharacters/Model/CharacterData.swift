//
//  CharacterData.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 30/9/21.
//

import Foundation

struct ResponseCharacters: Decodable {
    var code: Int
    var data: ResponseCharactersData
}

struct ResponseCharactersData: Decodable {
    let offset, limit, total, count: Int
    let all: [Character]
  
    enum CodingKeys: String, CodingKey {
        case offset, limit, total, count
        case all = "results"
    }
}

struct Character: Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
    let series: Series
}

struct Thumbnail: Decodable {
    let path, typeExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case typeExtension = "extension"
    }

}

struct DateMarvel: Decodable {
    let type, date : String
}

struct Series: Decodable {
    let available: Int
    let collectionURI: String
    let items: [Serie]
}

struct Serie: Decodable {
    let resourceURI, name: String
}
