//
//  CharactersRepositoryTests.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 18/10/22.
//

import XCTest
@testable import MarvelCharacters
import RxSwift

class CharactersRepositoryTests: XCTestCase {

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    let disposeBag = DisposeBag()

    // ------------------------------------------------
    // MARK: - Tests
    // ------------------------------------------------

    func testFetchCharacters_whenSuccessfully() {

        let networkService = DefaultNetworkServiceMock(apiDataNetworkConfig: ApiDataNetworkConfig(baseURL: "CharactersMock", publicKey: "", privateKey: ""))

        let charactersRepository = CharactersRepository(netWorkService: networkService)

        // when
        charactersRepository.fetchCharcters(limit: 20, offset: 20)
            .subscribe { event in
                switch event {
                case .next(let responseCharactersData):

                    // then
                    XCTAssertEqual(responseCharactersData.characters?.count, 2)
                    XCTAssertEqual(responseCharactersData.characters?[0].name, "3-D Man")
                    XCTAssertEqual(responseCharactersData.characters?[0].imageUrl, "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")
                case .error:
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }

    func testFetchCharacters_whenSuccessFailure() {

        let networkService = DefaultNetworkServiceMock(apiDataNetworkConfig: ApiDataNetworkConfig(baseURL: "", publicKey: "", privateKey: ""))

        let charactersRepository = CharactersRepository(netWorkService: networkService)

        // when
        charactersRepository.fetchCharcters(limit: 20, offset: 20)
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
