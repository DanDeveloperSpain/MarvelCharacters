//
//  SeriesRepositoryTests.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 18/10/22.
//

import XCTest
@testable import MarvelCharacters
import RxSwift

class SeriesRepositoryTests: XCTestCase {

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    let disposeBag = DisposeBag()

    // ------------------------------------------------
    // MARK: - Tests
    // ------------------------------------------------

    func testFetchSeries_whenSuccessfully() {

        let networkService = DefaultNetworkServiceMock(apiDataNetworkConfig: ApiDataNetworkConfig(baseURL: "SeriesMock", publicKey: "", privateKey: ""))

        let seriesRepository = SeriesRepository(netWorkService: networkService)

        // when
        seriesRepository.fetchSeries(characterId: "1", limit: 20, offset: 20)
            .subscribe { event in
                switch event {
                case .next(let responseSeriesData):

                    // then
                    XCTAssertEqual(responseSeriesData.series?.count, 2)
                    XCTAssertEqual(responseSeriesData.series?[0].title, "Avengers: The Initiative (2007 - 2010)")
                    XCTAssertEqual(responseSeriesData.series?[0].imageUrl, "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/514a2ed3302f5.jpg")
                case .error:
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }

    func testFetchSeries_Failure() {

        let networkService = DefaultNetworkServiceMock(apiDataNetworkConfig: ApiDataNetworkConfig(baseURL: "", publicKey: "", privateKey: ""))

        let seriesRepository = SeriesRepository(netWorkService: networkService)

        // when
        seriesRepository.fetchSeries(characterId: "1", limit: 20, offset: 20)
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
