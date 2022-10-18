//
//  ComicsRepositoryTests.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 18/10/22.
//

import XCTest
@testable import MarvelCharacters
import RxSwift

class ComicsRepositoryTests: XCTestCase {

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    let disposeBag = DisposeBag()

    // ------------------------------------------------
    // MARK: - Tests
    // ------------------------------------------------

    func testFetchComics_whenSuccessfully() {

        let networkService = DefaultNetworkServiceMock(apiDataNetworkConfig: ApiDataNetworkConfig(baseURL: "ComicsMock", publicKey: "", privateKey: ""))

        let comicsRepository = ComicsRepository(netWorkService: networkService)

        // when
        comicsRepository.fetchComics(characterId: "1", limit: 20, offset: 20)
            .subscribe { event in
                switch event {
                case .next(let responseComicsData):

                    // then
                    XCTAssertEqual(responseComicsData.comics?.count, 3)
                    XCTAssertEqual(responseComicsData.comics?[0].title, "Avengers: The Initiative (2007) #19")
                    XCTAssertEqual(responseComicsData.comics?[0].imageUrl, "http://i.annihil.us/u/prod/marvel/i/mg/d/03/58dd080719806.jpg")
                    XCTAssertEqual(responseComicsData.comics?[0].startDate, "dic. 17, 2008")
                case .error:
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }

    func testFetchComics_Failure() {

        let networkService = DefaultNetworkServiceMock(apiDataNetworkConfig: ApiDataNetworkConfig(baseURL: "", publicKey: "", privateKey: ""))

        let comicsRepository = ComicsRepository(netWorkService: networkService)

        // when
        comicsRepository.fetchComics(characterId: "1", limit: 20, offset: 20)
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
