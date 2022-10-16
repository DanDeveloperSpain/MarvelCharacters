//
//  CharacterDummyService.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 2/10/21.
//

import Foundation
@testable import MarvelCharacters

//class CharacterDummyService: CharacterServiceProtocol {
//
//    // let exceptionHandler = ExceptionHandlerHelper()
//
//    func requestGetCharacter(limit: Int, offset: Int) async throws -> ResponseCharacters {
//
//        return try await withCheckedThrowingContinuation { continuation in
//            do {
//                var data = Data()
//                if let url = Bundle(for: type(of: self)).url(forResource: "CharactersMock", withExtension: "json") {
//                    data = try Data(contentsOf: url)
//                }
//                let resultResponse = try JSONDecoder().decode(ResponseCharacters.self, from: data)
//                continuation.resume(returning: resultResponse)
//            } catch {
//                continuation.resume(throwing: error)
//            }
//        }
//    }
//
//    func requestGetComicsByCharacter(characterId: Int, limit: Int, offset: Int) async throws -> ResponseComics {
//        return try await withCheckedThrowingContinuation { continuation in
//            do {
//                var data = Data()
//                if let url = Bundle(for: type(of: self)).url(forResource: "ComicsMock", withExtension: "json") {
//                    data = try Data(contentsOf: url)
//                }
//                let resultResponse = try JSONDecoder().decode(ResponseComics.self, from: data)
//                continuation.resume(returning: resultResponse)
//            } catch let error {
//                continuation.resume(throwing: error)
//            }
//        }
//
//    }
//
//    func requestGetSeriesByCharacter(characterId: Int, limit: Int, offset: Int) async throws -> ResponseSeries {
//        return try await withCheckedThrowingContinuation { continuation in
//            do {
//                var data = Data()
//                if let url = Bundle(for: type(of: self)).url(forResource: "SeriesMock", withExtension: "json") {
//                    data = try Data(contentsOf: url)
//                }
//                let resultResponse = try JSONDecoder().decode(ResponseSeries.self, from: data)
//                continuation.resume(returning: resultResponse)
//            } catch let error {
//                continuation.resume(throwing: error)
//            }
//
//        }
//    }
//
//    func isMoreDataToLoad(offset: Int, total: Int, limit: Int) -> Bool {
//        return true
//    }
//
//    func numLastItemToShow(offset: Int, all: Int) -> Int {
//        return 0
//    }
//
//    func getErrorDescriptionToUser(statusCode: Int) -> String {
//        return "" //exceptionHandler.manageError(statusCode)
//    }
//
//}
