//
//  FetchComicsUseCase.swift
//  MarvelComics
//
//  Created by Daniel Pérez Parreño on 3/6/22.
//

import Foundation
import RxSwift

protocol FetchComicsUseCaseProtocol: AnyObject {
    func execute(characterId: String, limit: Int, offset: Int) -> Observable<ResponseComics>
}

final class FetchComicsUseCase: FetchComicsUseCaseProtocol {

    private let comicsRepository: ComicsRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(comicsRepository: ComicsRepositoryProtocol) {
        self.comicsRepository = comicsRepository
    }

    func execute(characterId: String, limit: Int, offset: Int) -> Observable<ResponseComics> {
        return Observable.create { [weak self] observer in
            self?.comicsRepository.fetchComics(characterId: characterId, limit: limit, offset: offset)
                .subscribe { event in
                    switch event {
                    case .next(let responseComicsData):
                        observer.onNext(responseComicsData)
                        observer.onCompleted()
                    case .error(let error):
                        observer.onError(error)
                    case .completed:
                        break
                    }
                }.disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
}
