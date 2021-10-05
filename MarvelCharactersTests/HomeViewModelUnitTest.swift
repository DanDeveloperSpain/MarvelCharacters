//
//  HomeViewModelUnitTest.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 2/10/21.
//

import XCTest
@testable import MarvelCharacters

class HomeViewModelUnitTest: XCTestCase {

    private(set) var homeViewModel: HomeViewModel?
    let characterDummyService = CharacterDummyService()
    
    override func setUp() {
        let router = HomeRouter()
        homeViewModel = HomeViewModel(router: router, characterService: characterDummyService)
        homeViewModel?.getCharacters()
    }

    func testGetCharactersHomeViewModel() {
        XCTAssertEqual(homeViewModel?.characters.count, 2)
    }

    func testNumLastCharacterToShow() {
        let areThereApiKeys = Constants.ApiKeys.publicKey.isEmpty || Constants.ApiKeys.privateKey.isEmpty ? false : true
        XCTAssertEqual(homeViewModel?.checkApiKeys(), areThereApiKeys)
    }
}
