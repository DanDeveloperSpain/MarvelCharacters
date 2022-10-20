//
//  FetchSeriesUseCaseTest.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 16/10/22.
//

import XCTest
@testable import MarvelCharacters
import RxSwift

class FetchSeriesUseCaseTest: XCTestCase {

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    lazy var seriesRepositoryMock: SeriesRepositoryProtocol = {
       return SeriesRespositoryMock()
    }()

    private let disposeBag = DisposeBag()

    var useCase: FetchSeriesUseCase?

    // ------------------------------------------------
    // MARK: - Tests
    // ------------------------------------------------

    override func setUp() {

        useCase = FetchSeriesUseCase(seriesRepository: seriesRepositoryMock)

    }

    func testFetchSeriesUseCase_whenSuccessfully() {

        // when
        useCase?.execute(characterId: "1", limit: 60, offset: 20)
            .subscribe { event in
                switch event {
                case .next(let responseSeries):

                    // then
                    XCTAssertEqual(responseSeries.series?.count, 2)
                    XCTAssertEqual(responseSeries.series?[0].title, "Avangers Forever")
                case .error:
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }

    func testFetchSeriesUseCase_whenFailure() {

        // when
        useCase?.execute(characterId: "1", limit: 60, offset: 80)
            .subscribe { event in
                switch event {
                case .next:
                    break
                case .error(let error):
                    let nsError = error as NSError

                    // then
                    XCTAssertEqual(nsError.code, 400)
                    XCTAssertEqual(nsError.domain, NSLocalizedString("invalid_response", comment: ""))
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }

}
