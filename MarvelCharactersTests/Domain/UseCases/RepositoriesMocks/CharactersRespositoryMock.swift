//
//  CharactersRespositoryMock.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 18/10/22.
//

import Foundation
@testable import MarvelCharacters
import RxSwift

final class CharactersRespositoryMock: CharactersRepositoryProtocol {

    // ------------------------------------------------
    // MARK: - Entities Mock
    // ------------------------------------------------

    static let characters: [Character] = {
        let character1 = Character(id: 1, name: "IronMan", description: "description IronMan", imageUrl: "http://i.annihil.us/IronMan.jpg")
        let character2 = Character(id: 2, name: "Vision", description: "description Vision", imageUrl: "http://i.annihil.us/Vision.jpg")
        return [character1, character2]
    }()

    let responseCharacters = ResponseCharacters(total: 40, characters: characters)

    // ------------------------------------------------
    // MARK: - Respository Mock
    // ------------------------------------------------

    let error = NSError(domain: ErrorResponse.invalidEndpoint.description, code: 404, userInfo: nil)

    func fetchCharcters(limit: Int, offset: Int) -> Observable<ResponseCharacters> {
        return Observable.create { observer in
            if offset > limit {
                observer.onError(self.error)
            } else {
                observer.onNext(self.responseCharacters)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

}
