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
    // MARK: - Entities Mock
    // ------------------------------------------------

    static let charactersFisrtRequest: [Character] = {
        let character1 = Character(id: 1, name: "IronMan", description: "description IronMan", imageUrl: "http://i.annihil.us/IronMan.jpg")
        let character2 = Character(id: 2, name: "Vision", description: "description Vision", imageUrl: "http://i.annihil.us/Vision.jpg")
        return [character1, character2]
    }()

    static let responseCharactersFisrtRequest = ResponseCharacters(total: 40, characters: charactersFisrtRequest)

    static let charactersSecondRequest: [Character] = {
        let character1 = Character(id: 3, name: "Spiderman", description: "description IronMan", imageUrl: "http://i.annihil.us/Spiderman.jpg")
        let character2 = Character(id: 4, name: "Wanda", description: "description Vision", imageUrl: "http://i.annihil.us/Wanda.jpg")
        return [character1, character2]
    }()

    static let responseCharactersSecondRequest = ResponseCharacters(total: 40, characters: charactersSecondRequest)

    // ------------------------------------------------
    // MARK: - UseCase Mock
    // ------------------------------------------------

    final class FetchCharactersUseCaseMock: FetchCharactersUseCaseProtocol {

        let error = NSError(domain: ErrorResponse.invalidEndpoint.description, code: 404, userInfo: nil)

        func execute(limit: Int, offset: Int) -> Observable<ResponseCharacters> {
            return Observable.create { observer in
                if offset == 0 {
                    observer.onNext(responseCharactersFisrtRequest)
                    observer.onCompleted()
                } else if offset == 20 {
                    observer.onNext(responseCharactersSecondRequest)
                    observer.onCompleted()
                } else if offset == 40 {
                    /// simulate error at third request
                    observer.onError(self.error)
                }
                return Disposables.create()
            }
        }

    }

    lazy var fetchCharactersUseCaseMock: FetchCharactersUseCaseProtocol = {
       return FetchCharactersUseCaseMock()
    }()

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    private let disposeBag = DisposeBag()

    private(set) var charactersListViewModel: CharactersListViewModel?

    var errorMessage: String?

    // ------------------------------------------------
    // MARK: - Tests
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
        XCTAssertEqual(self.errorMessage, "Ooops, there is something problem with the endpoint")

    }

}
