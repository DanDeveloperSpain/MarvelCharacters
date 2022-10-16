//
//  HomeViewModelUnitTest.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 2/10/21.
//

import XCTest
@testable import MarvelCharacters

class HomeViewModelUnitTest: XCTestCase {

    private(set) var homeViewModel: CharactersListViewModel?

    override func setUp() {
//        let characterDummyService = CharacterDummyService()
        let navigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController)

//        homeViewModel = CharactersListViewModel(coordinatorDelegate: homeCoordinator, characterService: characterDummyService)
//
//        homeViewModel?.start()

        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)

    }

    func testGetCharactersHomeViewModel() {
//        let numCharacters = homeViewModel?.characters.count
//        XCTAssertEqual(numCharacters, 2)
    }

    func testNumberOfItemsInSection() {
//        let numCharacters = homeViewModel?.characters.count
//        let numberOfItemsInSection = homeViewModel?.numberOfItemsInSection(section: 0)
//        XCTAssertEqual(numberOfItemsInSection, numCharacters)
    }

    func testCharacterNameAtIndex() {
//        let characterNameAtIndex = homeViewModel?.characterNameAtIndex(index: 0)
//        XCTAssertEqual(characterNameAtIndex, "3-D Man")
    }

    func testCharacterUrlImgeAtIndex() {
//        let characterUrlImgeAtIndex = homeViewModel?.characterUrlImgeAtIndex(index: 0)
//        XCTAssertEqual(characterUrlImgeAtIndex, "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")
    }

    func testCheckApiKeys() {
//        if Constants.ApiKeys.publicKey == "" || Constants.ApiKeys.privateKey == "" {
//            XCTAssertEqual(homeViewModel?.checkApiKeys(), false)
//        } else {
//            XCTAssertEqual(homeViewModel?.checkApiKeys(), true)
//        }
    }
}
