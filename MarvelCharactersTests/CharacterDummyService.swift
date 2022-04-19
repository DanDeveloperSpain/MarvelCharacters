//
//  CharacterDummyService.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 2/10/21.
//

import Foundation
@testable import MarvelCharacters

class CharacterDummyService : CharacterServiceProtocol {

    let exceptionHandler = ExceptionHandlerHelper()

    func requestGetCharacter(limit: Int, offset: Int) async throws -> ResponseCharactersData {
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
                  },
                  {
                    "id": 1017100,
                    "name": "A-Bomb (HAS)",
                    "description": "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction! ",
                    "modified": "2013-09-18T15:54:04-0400",
                    "thumbnail": {
                      "path": "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16",
                      "extension": "jpg"
                    },
                    "resourceURI": "http://gateway.marvel.com/v1/public/characters/1017100",
                    "comics": {
                      "available": 2,
                      "collectionURI": "http://gateway.marvel.com/v1/public/characters/1017100/comics",
                      "items": [
                        {
                          "resourceURI": "http://gateway.marvel.com/v1/public/comics/47176",
                          "name": "FREE COMIC BOOK DAY 2013 1 (2013) #1"
                        },
                        {
                          "resourceURI": "http://gateway.marvel.com/v1/public/comics/40628",
                          "name": "Hulk (2008) #55"
                        }
                      ],
                      "returned": 2
                    },
                    "series": {
                      "available": 2,
                      "collectionURI": "http://gateway.marvel.com/v1/public/characters/1017100/series",
                      "items": [
                        {
                          "resourceURI": "http://gateway.marvel.com/v1/public/series/17765",
                          "name": "FREE COMIC BOOK DAY 2013 1 (2013)"
                        },
                        {
                          "resourceURI": "http://gateway.marvel.com/v1/public/series/3374",
                          "name": "Hulk (2008 - 2012)"
                        }
                      ],
                      "returned": 2
                    }
                  }
                ]
              }
            }
        """
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let resultResponse = try JSONDecoder().decode(ResponseCharacters.self, from: Data(result.utf8))
                continuation.resume(returning: resultResponse.data)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func requestGetComicsByCharacter(characterId: Int, limit: Int, offset: Int) async throws -> ResponseComicsData {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let resultResponse = try JSONDecoder().decode(ResponseComicsData.self, from: Data())
                continuation.resume(returning: resultResponse)
            } catch let error {
                continuation.resume(throwing: error)
            }
        }
        
    }
    
    func requestGetSeriesByCharacter(characterId: Int, limit: Int, offset: Int) async throws -> ResponseSeriesData {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let resultResponse = try JSONDecoder().decode(ResponseSeriesData.self, from: Data())
                continuation.resume(returning: resultResponse)
            } catch let error {
                continuation.resume(throwing: error)
            }
        
        }
    }
    
    func isMoreDataToLoad(offset: Int, total: Int, limit: Int) -> Bool {
        return true
    }
    
    func numLastItemToShow(offset: Int, all: Int) -> Int {
        return 0
    }
    
    func getErrorDescriptionToUser(statusCode: Int) -> String {
        return exceptionHandler.manageError(statusCode)
    }

}
