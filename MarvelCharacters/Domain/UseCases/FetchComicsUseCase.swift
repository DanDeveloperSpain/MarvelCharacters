//
//  FetchComicsUseCase.swift
//  MarvelComics
//
//  Created by Daniel Pérez Parreño on 3/6/22.
//

import Foundation
import RxSwift

protocol FetchComicsUseCaseProtocol: AnyObject {
    func execute(limit: Int, offset: Int, characterId: String) -> Observable<ResponseComicsData>
}

final class FetchComicsUseCase: FetchComicsUseCaseProtocol {

    private let comicsRepository: ComicsRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(comicsRepository: ComicsRepositoryProtocol) {
        self.comicsRepository = comicsRepository
    }

    func execute(limit: Int, offset: Int, characterId: String) -> Observable<ResponseComicsData> {
        return Observable.create { [weak self] observer in
            self?.comicsRepository.fetchCharcters(characterId: characterId, limit: limit, offset: offset)
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
