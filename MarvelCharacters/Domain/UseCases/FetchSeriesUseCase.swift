//
//  FetchSeriesUseCase.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/6/22.
//

import Foundation
import RxSwift

protocol FetchSeriesUseCaseProtocol: AnyObject {
    func execute(characterId: String, limit: Int, offset: Int) -> Observable<ResponseSeriesData>
}

final class FetchSeriesUseCase: FetchSeriesUseCaseProtocol {

    private let seriesRepository: SeriesRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(seriesRepository: SeriesRepositoryProtocol) {
        self.seriesRepository = seriesRepository
    }

    func execute(characterId: String, limit: Int, offset: Int) -> Observable<ResponseSeriesData> {
        return Observable.create { [weak self] observer in
            self?.seriesRepository.fetchCharcters(characterId: characterId, limit: limit, offset: offset)
                .subscribe { event in
                    switch event {
                    case .next(let responseSeriesData):
                        observer.onNext(responseSeriesData)
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
