//
//  CharacterDetailViewModelTests.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 17/10/22.
//

import XCTest
@testable import MarvelCharacters
import RxSwift

class CharacterDetailViewModelTests: XCTestCase {

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    lazy var fetchComicsUseCaseMock: FetchComicsUseCaseProtocol = {
       return FetchComicsUseCaseMock()
    }()

    lazy var fetchSeriesUseCaseMock: FetchSeriesUseCaseProtocol = {
       return FetchSeriesUseCaseMock()
    }()

    private let disposeBag = DisposeBag()

    private(set) var characterDetailViewModel: CharacterDetailViewModel?

    var errorMessage: String?

    // ------------------------------------------------
    // MARK: - SetUp
    // ------------------------------------------------

    override func setUp() {
        let navigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController)

        let character = Character(id: 1, name: "Hulk", description: "Hulk description", imageUrl: "http://i.annihil.us/Hulk.jpg")

        characterDetailViewModel = CharacterDetailViewModel(coordinatorDelegate: homeCoordinator, fetchComicsUseCase: fetchComicsUseCaseMock, fetchSeriesUseCase: fetchSeriesUseCaseMock, character: character)

        characterDetailViewModel?.start()

        /// Subscribe to ViewModel's PublishSubject errorMessage
        characterDetailViewModel?.errorMessage.subscribe { event in
            self.errorMessage = event
        }.disposed(by: disposeBag)

    }

    // ------------------------------------------------
    // MARK: - Comic Tests
    // ------------------------------------------------

    func test_SuccessfullyFetchComicsUseCaseReturns_WhenAfterTheFirstRequest() {
        // when
        /// first request at setup

        // then
        let numComics = characterDetailViewModel?.comics.count
        XCTAssertEqual(numComics, 2)
        XCTAssertEqual(characterDetailViewModel?.comics[0].title, "X-Men Red")
    }

    func test_thereAreMoreComicsToFetch_WhenAfterTheFirstRequest() {
        // when
        /// first request at setup

        // then
        XCTAssertEqual(characterDetailViewModel?.offsetComic, 20)
        XCTAssertEqual(characterDetailViewModel?.loadMoreComic, true)

    }

    func test_SuccessfullyFetchComicsUseCaseReturns_WhenAfterTheSecondRequest() {
        // when
        /// second request
        characterDetailViewModel?.checkComicsRequestNewDataByIndex(index: 19)

        // then
        let numComics = characterDetailViewModel?.comics.count
        XCTAssertEqual(numComics, 4)
        XCTAssertEqual(characterDetailViewModel?.comics[3].title, "Avangers")

    }

    func test_thereAreMoreComicsToFetch_WhenAfterTheSecondRequest() {
        // when
        /// second request
        characterDetailViewModel?.checkComicsRequestNewDataByIndex(index: 19)

        // then
        XCTAssertEqual(characterDetailViewModel?.offsetComic, 40)
        XCTAssertEqual(characterDetailViewModel?.loadMoreComic, false)

    }

    func test_FailureFetchComicsUseCaseReturns_WhenAfterTheThirdRequest() {
        // when
        /// second request
        characterDetailViewModel?.checkComicsRequestNewDataByIndex(index: 19)
        /// force third request
        characterDetailViewModel?.fetchComicsLaunchesList()

        // then
        XCTAssertEqual(self.errorMessage, "Ooops, there is something problem with the serialization process")

    }

    // ------------------------------------------------
    // MARK: - Series Tests
    // ------------------------------------------------

    func test_SuccessfullyFetchSeriesUseCaseReturns_WhenAfterTheFirstRequest() {
        // when
        /// first request at setup

        // then
        let numSeries = characterDetailViewModel?.series.count
        XCTAssertEqual(numSeries, 2)
        XCTAssertEqual(characterDetailViewModel?.series[0].title, "Heralds")
    }

    func test_thereAreMoreSeriesToFetch_WhenAfterTheFirstRequest() {
        // when
        /// first request at setup

        // then
        XCTAssertEqual(characterDetailViewModel?.offsetSerie, 20)
        XCTAssertEqual(characterDetailViewModel?.loadMoreSerie, true)

    }

    func test_SuccessfullyFetchSeriesUseCaseReturns_WhenAfterTheSecondRequest() {
        // when
        /// second request
        characterDetailViewModel?.checkSeriesRequestNewDataByIndex(index: 19)

        // then
        let numComics = characterDetailViewModel?.series.count
        XCTAssertEqual(numComics, 4)
        XCTAssertEqual(characterDetailViewModel?.series[3].title, "Wolverine")

    }

    func test_thereAreMoreSeriesToFetch_WhenAfterTheSecondRequest() {
        // when
        /// second request
        characterDetailViewModel?.checkSeriesRequestNewDataByIndex(index: 19)

        // then
        XCTAssertEqual(characterDetailViewModel?.offsetSerie, 40)
        XCTAssertEqual(characterDetailViewModel?.loadMoreSerie, false)

    }

    func test_FailureFetchSeriesUseCaseReturns_WhenAfterTheThirdRequest() {
        // when
        /// second request
        characterDetailViewModel?.checkSeriesRequestNewDataByIndex(index: 19)
        /// force third request
        characterDetailViewModel?.fetchSeriesLaunchesList()

        // then
        XCTAssertEqual(self.errorMessage, "Ooops, there is something problem with the response")

    }
}
