//
//  CharacterDetailViewModelUnitTest.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 21/4/22.
//

import XCTest
@testable import MarvelCharacters

class CharacterDetailViewModelUnitTest: XCTestCase {
    
    private(set) var characterDetailViewModel: CharacterDetailViewModel?
    
    override func setUp() {
        let characterDummyService = CharacterDummyService()
        let navigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController)
        let character = Character(id: 0, name: "", description: "", thumbnail: Thumbnail(path: "", typeExtension: ""))
        
        characterDetailViewModel = CharacterDetailViewModel(coordinatorDelegate: homeCoordinator, character: character, characterService: characterDummyService)
        
        characterDetailViewModel?.start()
        
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
    }
    
    func testGetComicsCharacterDetailViewModel() {
        let numComics = characterDetailViewModel?.comics.count
        XCTAssertEqual(numComics, 3)
    }
    
    func testGetSeriesCharacterDetailViewModel() {
        let numComics = characterDetailViewModel?.series.count
        XCTAssertEqual(numComics, 2)
    }
    
    func testNumberOfSectionsInCollectionView() {
        let numberOfSections = characterDetailViewModel?.numberOfSections
        let returnNumberOfSections = characterDetailViewModel?.numberOfSectionsInCollectionView()
        XCTAssertEqual(numberOfSections, returnNumberOfSections)
    }
    
    func testNumberOfItemsInSection() {
        let numComics = characterDetailViewModel?.comics.count
        let comicsNumberOfItemsInSection = characterDetailViewModel?.numberOfItemsInSection(section: 0)
        let numSeries = characterDetailViewModel?.series.count
        let seriesNumberOfItemsInSection = characterDetailViewModel?.numberOfItemsInSection(section: 1)
        XCTAssertEqual(comicsNumberOfItemsInSection, numComics)
        XCTAssertEqual(seriesNumberOfItemsInSection, numSeries)
    }
    
    func testTitleAtIndex() {
        let comicTitleAtIndex = characterDetailViewModel?.titleAtIndex(index: 0, type: .comic)
        let serieTitleAtIndex = characterDetailViewModel?.titleAtIndex(index: 0, type: .serie)
        XCTAssertEqual(comicTitleAtIndex, "Avengers: The Initiative (2007) #19")
        XCTAssertEqual(serieTitleAtIndex, "Avengers: The Initiative (2007 - 2010)")
    }
    
    func testYearAtIndex() {
        let comicYearAtIndex = characterDetailViewModel?.yearAtIndex(index: 0, type: .comic)
        let serieYearAtIndex = characterDetailViewModel?.yearAtIndex(index: 0, type: .serie)
        XCTAssertEqual(comicYearAtIndex, "dic. 17, 2008")
        XCTAssertEqual(serieYearAtIndex, "2007")
    }
    
    func testUrlImgeAtIndex() {
        let comicUrlImgeAtIndex = characterDetailViewModel?.urlImgeAtIndex(index: 0, type: .comic)
        let serieUrlImgeAtIndex = characterDetailViewModel?.urlImgeAtIndex(index: 0, type: .serie)
        XCTAssertEqual(comicUrlImgeAtIndex, "http://i.annihil.us/u/prod/marvel/i/mg/d/03/58dd080719806.jpg")
        XCTAssertEqual(serieUrlImgeAtIndex, "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/514a2ed3302f5.jpg")
    }

}
