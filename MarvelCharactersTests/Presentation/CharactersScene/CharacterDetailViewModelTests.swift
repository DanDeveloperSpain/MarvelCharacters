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

    var yearsToFilter: [Int]?

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
        characterDetailViewModel?.errorMessage.subscribe {
            self.errorMessage = $0.element
        }.disposed(by: disposeBag)

        /// Subscribe to ViewModel's PublishSubject yearsToFilter
        characterDetailViewModel?.yearsToFilter.subscribe {
            self.yearsToFilter = $0.element
        }.disposed(by: disposeBag)

    }

    // ------------------------------------------------
    // MARK: - Filter Tests
    // ------------------------------------------------

    func test_SetFilterYearToItems() {

        // when
        /// second request comis and seires
        characterDetailViewModel?.checkComicsRequestNewDataByIndex(index: 19)
        characterDetailViewModel?.checkSeriesRequestNewDataByIndex(index: 19)

        /// select yera to filter
        // characterDetailViewModel?.selectedFilteredYear = 2007

        /// applying filter
        characterDetailViewModel?.setFilterYearToItems(yearToFilter: 2007)

        // then
        XCTAssertEqual(characterDetailViewModel?.filteredComics.count, 2)
        XCTAssertEqual(characterDetailViewModel?.filteredComics[0].title, "X-Men Red")
        XCTAssertEqual(characterDetailViewModel?.filteredSeries.count, 1)
        XCTAssertEqual(characterDetailViewModel?.filteredSeries[0].title, "Hulk")
    }

    func  test_SetYearsToFilter() {
        let arryYears = [0, 1993, 1999, 2001, 2006, 2007, 2009]

        // when
        /// second request comis and seires
        characterDetailViewModel?.checkComicsRequestNewDataByIndex(index: 19)
        characterDetailViewModel?.checkSeriesRequestNewDataByIndex(index: 19)

        // then
        XCTAssertEqual(yearsToFilter, arryYears)
    }

    // ------------------------------------------------
    // MARK: - Comic Tests
    // ------------------------------------------------

    func test_SuccessfullyFetchComicsUseCaseReturns_WhenAfterTheFirstRequest() {
        // when
        /// first request at setup

        // then
        let numComics = characterDetailViewModel?.allComics.count
        XCTAssertEqual(numComics, 2)
        XCTAssertEqual(characterDetailViewModel?.allComics[0].title, "X-Men Red")
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
        let numComics = characterDetailViewModel?.allComics.count
        XCTAssertEqual(numComics, 4)
        XCTAssertEqual(characterDetailViewModel?.allComics[3].title, "Avangers")

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
        XCTAssertEqual(self.errorMessage, NSLocalizedString("serialization_error", comment: ""))

    }

    // ------------------------------------------------
    // MARK: - Series Tests
    // ------------------------------------------------

    func test_SuccessfullyFetchSeriesUseCaseReturns_WhenAfterTheFirstRequest() {
        // when
        /// first request at setup

        // then
        let numSeries = characterDetailViewModel?.allSeries.count
        XCTAssertEqual(numSeries, 2)
        XCTAssertEqual(characterDetailViewModel?.allSeries[0].title, "Heralds")
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
        let numComics = characterDetailViewModel?.allSeries.count
        XCTAssertEqual(numComics, 4)
        XCTAssertEqual(characterDetailViewModel?.allSeries[3].title, "Wolverine")

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
        XCTAssertEqual(self.errorMessage, NSLocalizedString("invalid_response", comment: ""))

    }
}
