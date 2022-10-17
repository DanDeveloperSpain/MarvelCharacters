//
//  FetchComicsUseCaseTest.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 16/10/22.
//

import XCTest
@testable import MarvelCharacters
import RxSwift

class FetchComicsUseCaseTest: XCTestCase {

    // ------------------------------------------------
    // MARK: - Entities Mock
    // ------------------------------------------------

    static let comics: [Comic] = {
        let comic1 = Comic(id: 1, title: "Infinity Wars vol.1", imageUrl: "http://i.annihil.us/comics/inf1.jpg", startDate: "2007")
        let comic2 = Comic(id: 2, title: "Infinity Wars vol.2", imageUrl: "http://i.annihil.us/comics/inf2.jpg", startDate: "2008")
        return [comic1, comic2]
    }()

    static let responseComics = ResponseComics(total: 40, comics: comics)

    // ------------------------------------------------
    // MARK: - Respository Mock
    // ------------------------------------------------

    final class ComicsRespositoryMock: ComicsRepositoryProtocol {

        let error = NSError(domain: ErrorResponse.serializationError.description, code: 400, userInfo: nil)

        func fetchComics(characterId: String, limit: Int, offset: Int) -> Observable<ResponseComics> {
            return Observable.create { observer in
                if offset > limit {
                    observer.onError(self.error)
                } else {
                    observer.onNext(responseComics)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }

    }

    lazy var comicsRepositoryMock: ComicsRepositoryProtocol = {
       return ComicsRespositoryMock()
    }()

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    private let disposeBag = DisposeBag()

    var useCase: FetchComicsUseCase?

    // ------------------------------------------------
    // MARK: - Tests
    // ------------------------------------------------

    override func setUp() {

        useCase = FetchComicsUseCase(comicsRepository: comicsRepositoryMock)

    }

    func testFetchComicsUseCase_whenSuccessfully() {

        // when
        useCase?.execute(characterId: "1", limit: 60, offset: 20)
            .subscribe { event in
                switch event {
                case .next(let responseComics):

                    // then
                    XCTAssertEqual(responseComics.comics?.count, 2)
                    XCTAssertEqual(responseComics.comics?[0].title, "Infinity Wars vol.1")
                case .error:
                    break
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }

    func testFetchComicsUseCase_whenFailure() {

        // when
        useCase?.execute(characterId: "1", limit: 60, offset: 80)
            .subscribe { event in
                switch event {
                case .next:
                    break
                case .error(let error):

                    // then
                    let nsError = error as NSError
                    XCTAssertEqual(nsError.code, 400)
                    XCTAssertEqual(nsError.domain, "Ooops, there is something problem with the serialization process")
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)

    }
}
