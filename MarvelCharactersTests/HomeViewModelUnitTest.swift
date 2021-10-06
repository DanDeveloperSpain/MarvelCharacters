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

    func testApiKey() {
        if Constants.ApiKeys.publicKey == "" || Constants.ApiKeys.privateKey == "" {
            XCTAssertEqual(homeViewModel?.checkApiKeys(), false)
        } else {
            XCTAssertEqual(homeViewModel?.checkApiKeys(), true)
        }
    }
}
