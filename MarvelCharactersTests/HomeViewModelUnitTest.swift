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
    
    override func setUp() {
        let characterDummyService = CharacterDummyService()
        let navigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController)
        
        homeViewModel = HomeViewModel(coordinatorDelegate: homeCoordinator, characterService: characterDummyService)
        
    }

    func testGetCharactersHomeViewModel() {
        homeViewModel?.start()
        
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        
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
