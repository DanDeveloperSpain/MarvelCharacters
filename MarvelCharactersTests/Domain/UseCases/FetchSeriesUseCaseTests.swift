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
    // MARK: - Entities Mock
    // ------------------------------------------------

    static let series: [Serie] = {
        let serie1 = Serie(id: 1, startYear: 1998, title: "Avangers Forever", imageUrl: "http://i.annihil.us/series/AForever.jpg")
        let serie2 = Serie(id: 2, startYear: 1999, title: "Earth X", imageUrl: "http://i.annihil.us/series/EarthX.jpg")
        return [serie1, serie2]
    }()

    static let responseSeries = ResponseSeries(total: 40, series: series)

    // ------------------------------------------------
    // MARK: - Respository Mock
    // ------------------------------------------------

    final class SeriesRespositoryMock: SeriesRepositoryProtocol {

        let error = NSError(domain: ErrorResponse.invalidResponse.description, code: 400, userInfo: nil)

        func fetchSeries(characterId: String, limit: Int, offset: Int) -> Observable<ResponseSeries> {
            return Observable.create { observer in
                if offset > limit {
                    observer.onError(self.error)
                } else {
                    observer.onNext(responseSeries)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }

    }

    lazy var seriesRepositoryMock: SeriesRepositoryProtocol = {
       return SeriesRespositoryMock()
    }()

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

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
                    XCTAssertEqual(nsError.domain, "Ooops, there is something problem with the response")
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }

}
