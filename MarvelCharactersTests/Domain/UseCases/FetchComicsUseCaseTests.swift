//
//  FetchComicsUseCaseTest.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 16/10/22.
//

import XCTest
@testable import MarvelCharacters
import RxSwift

class FetchComicsUseCaseTest: XCTestCase {

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    lazy var comicsRepositoryMock: ComicsRepositoryProtocol = {
       return ComicsRespositoryMock()
    }()

    private let disposeBag = DisposeBag()

    var useCase: FetchComicsUseCase?

    // ------------------------------------------------
    // MARK: - Tests
    // ------------------------------------------------

    override func setUp() {

        useCase = FetchComicsUseCase(comicsRepository: comicsRepositoryMock)

    }

    func testFetchComicsUseCase_whenSuccessfully() {

        // when
        useCase?.execute(characterId: "1", limit: 60, offset: 20)
            .subscribe { event in
                switch event {
                case .next(let responseComics):

                    // then
                    XCTAssertEqual(responseComics.comics?.count, 2)
                    XCTAssertEqual(responseComics.comics?[0].title, "Infinity Wars vol.1")
                case .error:
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }

    func testFetchComicsUseCase_whenFailure() {

        // when
        useCase?.execute(characterId: "1", limit: 60, offset: 80)
            .subscribe { event in
                switch event {
                case .next:
                    break
                case .error(let error):

                    // then
                    let nsError = error as NSError
                    XCTAssertEqual(nsError.code, 400)
                    XCTAssertEqual(nsError.domain, "Ooops, there is something problem with the serialization process")
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }
}
