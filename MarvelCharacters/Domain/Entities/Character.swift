//
//  CharacterData.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 30/9/21.
//

import Foundation

struct ResponseCharacters: Decodable {
    let offset, total: Int?
    let characters: [Character]?
}

struct Character: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let imageUrl: String?
}
