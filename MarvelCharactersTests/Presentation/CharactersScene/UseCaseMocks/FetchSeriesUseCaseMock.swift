//
//  FetchSeriesUseCaseMock.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 18/10/22.
//

import Foundation
@testable import MarvelCharacters
import RxSwift

final class FetchSeriesUseCaseMock: FetchSeriesUseCaseProtocol {

    // ------------------------------------------------
    // MARK: - Entities Mock
    // ------------------------------------------------

    static let seriesFirstRequest: [Serie] = {
        let serie1 = Serie(id: 1, startYear: 2006, title: "Heralds", imageUrl: "http://i.annihil.us/Heralds.jpg")
        let serie2 = Serie(id: 2, startYear: 2007, title: "Hulk", imageUrl: "http://i.annihil.us/Hulk.jpg")
        return [serie1, serie2]
    }()

    let responseSeriesFirstRequest = ResponseSeries(total: 40, series: seriesFirstRequest)

    static let seriesSecondRequest: [Serie] = {
        let serie3 = Serie(id: 3, startYear: 1999, title: "X-Men Alpha", imageUrl: "http://i.annihil.us/X-MenAlpha.jpg")
        let serie4 = Serie(id: 4, startYear: 2001, title: "Wolverine", imageUrl: "http://i.annihil.us/Wolverine.jpg")
        return [serie3, serie4]
    }()

    let responseSeriesSecondRequest = ResponseSeries(total: 40, series: seriesSecondRequest)

    // ------------------------------------------------
    // MARK: - UseCases Mock
    // ------------------------------------------------

    let error = NSError(domain: ErrorResponse.invalidResponse.description, code: 400, userInfo: nil)

    func execute(characterId: String, limit: Int, offset: Int) -> Observable<ResponseSeries> {
        return Observable.create { observer in
            if offset == 0 {
                observer.onNext(self.responseSeriesFirstRequest)
                observer.onCompleted()
            } else if offset == 20 {
                observer.onNext(self.responseSeriesSecondRequest)
                observer.onCompleted()
            } else if offset == 40 {
                /// simulate error at third request
                observer.onError(self.error)
            }
            return Disposables.create()
        }
    }
}
