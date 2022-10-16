//
//  FetchCharactersUseCaseTest.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 16/10/22.
//

import XCTest
@testable import MarvelCharacters
import RxSwift

class FetchCharactersUseCaseTest: XCTestCase {

    // ------------------------------------------------
    // MARK: - Entities Mock
    // ------------------------------------------------

    static let characters: [Character] = {
        let character1 = Character(id: 1, name: "IronMan", description: "description IronMan", imageUrl: "http://i.annihil.us/IronMan.jpg")
        let character2 = Character(id: 2, name: "Vision", description: "description Vision", imageUrl: "http://i.annihil.us/Vision.jpg")
        return [character1, character2]
    }()

    static let responseCharacters = ResponseCharacters(offset: 20, total: 40, characters: characters)

    // ------------------------------------------------
    // MARK: - Respository Mock
    // ------------------------------------------------

    final class CharactersRespositoryMock: CharactersRepositoryProtocol {

        let error = NSError(domain: ErrorResponse.invalidEndpoint.description, code: 400, userInfo: nil)

        func fetchCharcters(limit: Int, offset: Int) -> Observable<ResponseCharacters> {
            return Observable.create { observer in
                if offset > limit {
                    observer.onError(self.error)
                } else {
                    observer.onNext(responseCharacters)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }

    }

    lazy var charactersRepositoryMock: CharactersRepositoryProtocol = {
       return CharactersRespositoryMock()
    }()

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    private let disposeBag = DisposeBag()

    var useCase: FetchCharactersUseCase?

    // ------------------------------------------------
    // MARK: - Tests
    // ------------------------------------------------

    override func setUp() {

        useCase = FetchCharactersUseCase(charactersRepository: charactersRepositoryMock)

    }

    func testFetchCharactersUseCase_whenSuccessfully() {

        useCase?.execute(limit: 60, offset: 20)
            .subscribe { event in
                switch event {
                case .next(let responseCharacter):
                    XCTAssertEqual(responseCharacter.characters?.count, 2)
                    XCTAssertEqual(responseCharacter.characters?[0].name, "IronMan")
                case .error:
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }

    func testFetchCharactersUseCase_whenFailure() {

        useCase?.execute(limit: 60, offset: 80)
            .subscribe { event in
                switch event {
                case .next:
                    break
                case .error(let error):
                    let nsError = error as NSError
                    XCTAssertEqual(nsError.code, 400)
                    XCTAssertEqual(nsError.domain, "Ooops, there is something problem with the endpoint")
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }

}
