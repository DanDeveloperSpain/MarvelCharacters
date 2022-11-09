//
//  FetchCharactersUseCaseTest.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 16/10/22.
//

import XCTest
@testable import MarvelCharacters
import RxSwift

class FetchCharactersUseCaseTest: XCTestCase {

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    var charactersRepositoryMock: CharactersRepositoryProtocol!
    var useCase: FetchCharactersUseCase?
    var disposeBag: DisposeBag!

    // ------------------------------------------------
    // MARK: - Tests
    // ------------------------------------------------

    override func setUp() {
        super.setUp()
        charactersRepositoryMock = CharactersRespositoryMock()
        useCase = FetchCharactersUseCase(charactersRepository: charactersRepositoryMock)
        disposeBag = DisposeBag()

    }

    override func tearDown() {
        charactersRepositoryMock = nil
        useCase = nil
        disposeBag = nil
        super.tearDown()
    }

    func testFetchCharactersUseCase_whenSuccessfully() {

        let exp = expectation(description: "wait for data")
        var numChar = 0
        var charName = ""

        // when
        useCase?.execute(limit: 60, offset: 20)
            .subscribe { event in
                switch event {
                case .next(let responseCharacter):

                    // then
                    numChar = responseCharacter.characters?.count ?? 0
                    charName = responseCharacter.characters?.first?.name ?? ""
                    exp.fulfill()

                case .error:
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

        waitForExpectations(timeout: 1)
        XCTAssertEqual(numChar, 2)
        XCTAssertEqual(charName, "IronMan")

    }

    func testFetchCharactersUseCase_whenFailure() {

        let exp = expectation(description: "wait for data")
        var nsErrorCode = 0
        var nsErrorDomain = ""

        // when
        useCase?.execute(limit: 60, offset: 80)
            .subscribe { event in
                switch event {
                case .next:
                    break
                case .error(let error):

                    // then
                    let nsError = error as NSError
                    nsErrorCode = nsError.code
                    nsErrorDomain = nsError.domain
                    exp.fulfill()

                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

        waitForExpectations(timeout: 1)
        XCTAssertEqual(nsErrorCode, 404)
        XCTAssertEqual(nsErrorDomain, NSLocalizedString("invalid_endpoint", comment: ""))

    }

}
