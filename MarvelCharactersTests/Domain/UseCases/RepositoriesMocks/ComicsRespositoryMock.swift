//
//  ComicsRespositoryMock.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 18/10/22.
//

import Foundation
@testable import MarvelCharacters
import RxSwift

final class ComicsRespositoryMock: ComicsRepositoryProtocol {

    // ------------------------------------------------
    // MARK: - Entities Mock
    // ------------------------------------------------

    static let comics: [Comic] = {
        let comic1 = Comic(id: 1, title: "Infinity Wars vol.1", imageUrl: "http://i.annihil.us/comics/inf1.jpg", startDate: "2007")
        let comic2 = Comic(id: 2, title: "Infinity Wars vol.2", imageUrl: "http://i.annihil.us/comics/inf2.jpg", startDate: "2008")
        return [comic1, comic2]
    }()

    let responseComics = ResponseComics(total: 40, comics: comics)

    // ------------------------------------------------
    // MARK: - Respository Mock
    // ------------------------------------------------

    let error = NSError(domain: ErrorResponse.serializationError.description, code: 400, userInfo: nil)

    func fetchComics(characterId: String, limit: Int, offset: Int) -> Observable<ResponseComics> {
        return Observable.create { observer in
            if offset > limit {
                observer.onError(self.error)
            } else {
                observer.onNext(self.responseComics)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

}
