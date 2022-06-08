//
//  FetchSeriesUseCase.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/6/22.
//

import Foundation
import RxSwift

protocol FetchSeriesUseCaseProtocol: AnyObject {
    func execute(limit: Int, offset: Int, characterId: String) -> Observable<ResponseSeriesData>
}

final class FetchSeriesUseCase: FetchSeriesUseCaseProtocol {

    private let seriesRepository: SeriesRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(seriesRepository: SeriesRepositoryProtocol) {
        self.seriesRepository = seriesRepository
    }

    func execute(limit: Int, offset: Int, characterId: String) -> Observable<ResponseSeriesData> {
        return Observable.create { [weak self] observer in
            self?.seriesRepository.fetchCharcters(limit: limit, offset: offset, characterId: characterId)
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
