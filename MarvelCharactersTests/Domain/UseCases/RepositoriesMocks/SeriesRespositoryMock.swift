//
//  SeriesRespositoryMock.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 18/10/22.
//

import Foundation
@testable import MarvelCharacters
import RxSwift

final class SeriesRespositoryMock: SeriesRepositoryProtocol {

    // ------------------------------------------------
    // MARK: - Entities Mock
    // ------------------------------------------------

    static let series: [Serie] = {
        let serie1 = Serie(id: 1, startYear: 1998, title: "Avangers Forever", imageUrl: "http://i.annihil.us/series/AForever.jpg")
        let serie2 = Serie(id: 2, startYear: 1999, title: "Earth X", imageUrl: "http://i.annihil.us/series/EarthX.jpg")
        return [serie1, serie2]
    }()

    let responseSeries = ResponseSeries(total: 40, series: series)

    // ------------------------------------------------
    // MARK: - Respository Mock
    // ------------------------------------------------

    let error = NSError(domain: ErrorResponse.invalidResponse.description, code: 400, userInfo: nil)

    func fetchSeries(characterId: String, limit: Int, offset: Int) -> Observable<ResponseSeries> {
        return Observable.create { observer in
            if offset > limit {
                observer.onError(self.error)
            } else {
                observer.onNext(self.responseSeries)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

}
