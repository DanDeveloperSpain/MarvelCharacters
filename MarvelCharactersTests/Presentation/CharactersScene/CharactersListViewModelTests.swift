//
//  CharactersListViewModelTests.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 16/10/22.
//

import XCTest
@testable import MarvelCharacters
import RxSwift

class CharactersListViewModelTests: XCTestCase {

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    lazy var fetchCharactersUseCaseMock: FetchCharactersUseCaseProtocol = {
       return FetchCharactersUseCaseMock()
    }()

    private let disposeBag = DisposeBag()

    private(set) var charactersListViewModel: CharactersListViewModel?

    var errorMessage: String?

    // ------------------------------------------------
    // MARK: - SetUp
    // ------------------------------------------------

    override func setUp() {
        let navigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController)
        let appConfiguration = AppConfiguration()

        charactersListViewModel = CharactersListViewModel(coordinatorDelegate: homeCoordinator, fetchCharactersUseCase: fetchCharactersUseCaseMock, appConfiguration: appConfiguration)

        charactersListViewModel?.start()

        /// Subscribe to ViewModel's PublishSubject errorMessage
        charactersListViewModel?.errorMessage.subscribe { event in
            self.errorMessage = event
        }.disposed(by: disposeBag)
    }

    // ------------------------------------------------
    // MARK: - Tests
    // ------------------------------------------------

    func test_SuccessfullyFetchCharactersUseCaseReturns_WhenAfterTheFirstRequest() {
        // when
        /// first request at setup

        // then
        let numCharacters = charactersListViewModel?.characters.count
        XCTAssertEqual(numCharacters, 2)
        XCTAssertEqual(charactersListViewModel?.characters[0].name, "IronMan")

    }

    func test_thereAreMoreCharactersToFetch_WhenAfterTheFirstRequest() {
        // when
        /// first request at setup

        // then
        XCTAssertEqual(charactersListViewModel?.offset, 20)
        XCTAssertEqual(charactersListViewModel?.loadMore, true)

    }

    func test_SuccessfullyFetchCharactersUseCaseReturns_WhenAfterTheSecondRequest() {
        // when
        /// second request
        charactersListViewModel?.checkRequestNewDataByIndex(index: 19)

        // then
        let numCharacters = charactersListViewModel?.characters.count
        XCTAssertEqual(numCharacters, 4)
        XCTAssertEqual(charactersListViewModel?.characters[3].name, "Wanda")

    }

    func test_thereAreMoreCharactersToFetch_WhenAfterTheSecondRequest() {
        // when
        /// second request
        charactersListViewModel?.checkRequestNewDataByIndex(index: 19)

        // then
        XCTAssertEqual(charactersListViewModel?.offset, 40)
        XCTAssertEqual(charactersListViewModel?.loadMore, false)

    }

    func test_FailureFetchCharactersUseCaseReturns_WhenAfterTheThirdRequest() {
        // when
        /// second request
        charactersListViewModel?.checkRequestNewDataByIndex(index: 19)
        /// force third request
        charactersListViewModel?.fetchCharactersLaunchesList()

        // then
        XCTAssertEqual(self.errorMessage, NSLocalizedString("invalid_endpoint", comment: ""))

    }

}
