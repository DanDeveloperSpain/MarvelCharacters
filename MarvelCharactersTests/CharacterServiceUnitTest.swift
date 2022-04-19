//
//  CharacterServiceUnitTest.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 2/10/21.
//

import XCTest
@testable import MarvelCharacters

class CharacterServiceUnitTest: XCTestCase {

    let characterDummyService = CharacterDummyService()
    let characterService = CharacterService()
    
    var responseCharactersData : ResponseCharactersData?
    var characters : [Character] = []
    let limit : Int = 20
    var errorMessajeCharacter : String?
    
    override func setUp() async throws {
        
        do {
            let ressultCharacters = try await characterDummyService.requestGetCharacter(limit: limit, offset: 0)
            self.responseCharactersData = ressultCharacters
            self.characters += ressultCharacters.all ?? []
            
        } catch let error {
            self.errorMessajeCharacter = self.characterService.getErrorDescriptionToUser(statusCode: error.asAFError?.responseCode ?? 0)
        }
    }

    func testRequestCharactersSucces() throws {
        XCTAssertEqual(characters.count, 2)
        XCTAssertEqual(errorMessajeCharacter, nil)
    }
    
    func testIsMoreDataToLoad(){
        let loadMore = characterService.isMoreDataToLoad(offset: responseCharactersData?.offset ?? 0, total: responseCharactersData?.total ?? 0, limit: limit )
        XCTAssertEqual(loadMore, false)
    }
    
    func testNumLastItemToShow() {
        let numLastItem = characterService.numLastItemToShow(offset: responseCharactersData?.offset ?? 0, all: responseCharactersData?.all?.count ?? 0)
        XCTAssertEqual(numLastItem, 1)
    }

}
