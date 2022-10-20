//
//  FetchComicsUseCaseMock.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 18/10/22.
//

import Foundation
@testable import MarvelCharacters
import RxSwift

final class FetchComicsUseCaseMock: FetchComicsUseCaseProtocol {

    // ------------------------------------------------
    // MARK: - Entities Mock
    // ------------------------------------------------

    static let comicsFirstRequest: [Comic] = {
        let comic1 = Comic(id: 1, title: "X-Men Red", imageUrl: "http://i.annihil.us/X-MenRed.jpg", startDate: Date(), startYear: 2007)
        let comic2 = Comic(id: 2, title: "S.W.O.R.D", imageUrl: "http://i.annihil.us/S.W.O.R.D.jpg", startDate: Date(), startYear: 2009)
        return [comic1, comic2]
    }()

    let responseComicsFirstRequest = ResponseComics(total: 40, comics: comicsFirstRequest)

    static let comicsSecondRequest: [Comic] = {
        let comic3 = Comic(id: 3, title: "Spiderman", imageUrl: "http://i.annihil.us/Spiderman.jpg", startDate: Date(), startYear: 1993)
        let comic4 = Comic(id: 4, title: "Avangers", imageUrl: "http://i.annihil.us/Avangers.jpg", startDate: Date(), startYear: 2007)
        return [comic3, comic4]
    }()

    let responseComicsSecondRequest = ResponseComics(total: 40, comics: comicsSecondRequest)

    // ------------------------------------------------
    // MARK: - UseCases Mock
    // ------------------------------------------------

    let error = NSError(domain: ErrorResponse.serializationError.description, code: 400, userInfo: nil)

    func execute(characterId: String, limit: Int, offset: Int) -> Observable<ResponseComics> {
        return Observable.create { observer in
            if offset == 0 {
                observer.onNext(self.responseComicsFirstRequest)
                observer.onCompleted()
            } else if offset == 20 {
                observer.onNext(self.responseComicsSecondRequest)
                observer.onCompleted()
            } else if offset == 40 {
                /// simulate error at third request
                observer.onError(self.error)
            }
            return Disposables.create()
        }
    }
}
