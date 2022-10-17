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

    lazy var charactersRepositoryMock: CharactersRepositoryProtocol = {
       return CharactersRespositoryMock()
    }()

    private let disposeBag = DisposeBag()

    var useCase: FetchCharactersUseCase?

    // ------------------------------------------------
    // MARK: - Tests
    // ------------------------------------------------

    override func setUp() {

        useCase = FetchCharactersUseCase(charactersRepository: charactersRepositoryMock)

    }

    func testFetchCharactersUseCase_whenSuccessfully() {

        // when
        useCase?.execute(limit: 60, offset: 20)
            .subscribe { event in
                switch event {
                case .next(let responseCharacter):

                    // then
                    XCTAssertEqual(responseCharacter.characters?.count, 2)
                    XCTAssertEqual(responseCharacter.characters?[0].name, "IronMan")
                case .error:
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }

    func testFetchCharactersUseCase_whenFailure() {

        // when
        useCase?.execute(limit: 60, offset: 80)
            .subscribe { event in
                switch event {
                case .next:
                    break
                case .error(let error):

                    // then
                    let nsError = error as NSError
                    XCTAssertEqual(nsError.code, 404)
                    XCTAssertEqual(nsError.domain, "Ooops, there is something problem with the endpoint")
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }

}
