//
//  FetchCharactersUseCase.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 31/5/22.
//

import Foundation
import RxSwift

protocol FetchCharactersUseCaseProtocol: AnyObject {
    func execute(limit: Int, offset: Int) -> Observable<ResponseCharacters>
}

final class FetchCharactersUseCase: FetchCharactersUseCaseProtocol {

    private let charactersRepository: CharactersRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(charactersRepository: CharactersRepositoryProtocol) {
        self.charactersRepository = charactersRepository
    }

    func execute(limit: Int, offset: Int) -> Observable<ResponseCharacters> {
        return Observable.create { [weak self] observer in
            self?.charactersRepository.fetchCharcters(limit: limit, offset: offset)
                .subscribe { event in
                    switch event {
                    case .next(let responseCharactersData):
                        observer.onNext(responseCharactersData)
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
