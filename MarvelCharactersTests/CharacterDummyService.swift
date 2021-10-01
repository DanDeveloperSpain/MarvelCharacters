//
//  CharacterDummyService.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 2/10/21.
//

import Foundation
@testable import MarvelCharacters

class CharacterDummyService : CharacterServiceProtocol {
    
    func requestGetCharacter(limit: Int, offset: Int, withSuccess: @escaping (ResponseCharactersData) -> Void, withFailure: @escaping (String) -> Void) {
        let result = """
            {
              "code": 200,
              "status": "Ok",
              "etag": "1ba0959a7780df422d627be3e06a3d20f000ff2c",
              "data": {
                "offset": 0,
                "limit": 1,
                "total": 1,
                "count": 1,
                "results": [
                  {
                    "id": 1011334,
                    "name": "3-D Man",
                    "description": "",
                    "thumbnail": {
                      "path": "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
                      "extension": "jpg"
                    },
                    "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011334",
                    "comics": {
                      "available": 12,
                      "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011334/comics",
                      "items": [
                        {
                          "resourceURI": "http://gateway.marvel.com/v1/public/comics/21366",
                          "name": "Avengers: The Initiative (2007) #14"
                        },
                        {
                          "resourceURI": "http://gateway.marvel.com/v1/public/comics/10224",
                          "name": "Marvel Premiere (1972) #36"
                        }
                      ],
                      "returned": 12
                    },
                    "series": {
                      "available": 3,
                      "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011334/series",
                      "items": [
                        {
                          "resourceURI": "http://gateway.marvel.com/v1/public/series/1945",
                          "name": "Avengers: The Initiative (2007 - 2010)"
                        }
                      ],
                      "returned": 3
                    }
                  }
                ]
              }
            }
        """
        let resultResponse = try! JSONDecoder().decode(ResponseCharacters.self, from: Data(result.utf8))
        withSuccess(resultResponse.data)
    }
    
    func requestGetComicsByCharacter(characterId: Int, limit: Int, offset: Int, withSuccess: @escaping (ResponseComicsData) -> Void, withFailure: @escaping (String) -> Void) {
        let resultResponse = try! JSONDecoder().decode(ResponseComicsData.self, from: Data())
        withSuccess(resultResponse)
    }
    
    func requestGetSeriesByCharacter(characterId: Int, limit: Int, offset: Int, withSuccess: @escaping (ResponseSeriesData) -> Void, withFailure: @escaping (String) -> Void) {
        let resultResponse = try! JSONDecoder().decode(ResponseSeriesData.self, from: Data())
        withSuccess(resultResponse)
    }
    
    func isMoreDataToLoad(offset: Int, total: Int, limit: Int) -> Bool {
        return true
    }

}
