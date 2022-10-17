//
//  FetchCharactersUseCaseMock.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 18/10/22.
//

import Foundation
@testable import MarvelCharacters
import RxSwift

final class FetchCharactersUseCaseMock: FetchCharactersUseCaseProtocol {

    // ------------------------------------------------
    // MARK: - Entities Mock
    // ------------------------------------------------

    static let charactersFisrtRequest: [Character] = {
        let character1 = Character(id: 1, name: "IronMan", description: "description IronMan", imageUrl: "http://i.annihil.us/IronMan.jpg")
        let character2 = Character(id: 2, name: "Vision", description: "description Vision", imageUrl: "http://i.annihil.us/Vision.jpg")
        return [character1, character2]
    }()

    let responseCharactersFisrtRequest = ResponseCharacters(total: 40, characters: charactersFisrtRequest)

    static let charactersSecondRequest: [Character] = {
        let character3 = Character(id: 3, name: "Spiderman", description: "description IronMan", imageUrl: "http://i.annihil.us/Spiderman.jpg")
        let character4 = Character(id: 4, name: "Wanda", description: "description Vision", imageUrl: "http://i.annihil.us/Wanda.jpg")
        return [character3, character4]
    }()

    let responseCharactersSecondRequest = ResponseCharacters(total: 40, characters: charactersSecondRequest)

    // ------------------------------------------------
    // MARK: - UseCase Mock
    // ------------------------------------------------

    let error = NSError(domain: ErrorResponse.invalidEndpoint.description, code: 404, userInfo: nil)

    func execute(limit: Int, offset: Int) -> Observable<ResponseCharacters> {
        return Observable.create { observer in
            if offset == 0 {
                observer.onNext(self.responseCharactersFisrtRequest)
                observer.onCompleted()
            } else if offset == 20 {
                observer.onNext(self.responseCharactersSecondRequest)
                observer.onCompleted()
            } else if offset == 40 {
                /// simulate error at third request
                observer.onError(self.error)
            }
            return Disposables.create()
        }
    }

}
