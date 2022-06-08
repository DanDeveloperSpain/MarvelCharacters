//
//  SeriesRepository.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/6/22.
//

import Foundation
import RxSwift

final class SeriesRepository {

    private let netWorkService: NetworkServiceProtocol
    // private let chache: CharacterResponseStorage

    init(netWorkService: NetworkServiceProtocol) {
        self.netWorkService = netWorkService
    }

}

extension SeriesRepository: SeriesRepositoryProtocol {

    func fetchCharcters(limit: Int, offset: Int, characterId: String) -> Observable<ResponseSeriesData> {

        // DataBase Cache

        return Observable.create { observer in
            self.fetchSeriesFromNetwork(limit: limit, offset: offset, characterId: characterId) { result in
                switch result {
                case .success(let responseSeriesData):
                    observer.onNext(responseSeriesData)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    private func fetchSeriesFromNetwork(limit: Int, offset: Int, characterId: String, complete completion: @escaping (Result<ResponseSeriesData, Error>) -> Void) {
        netWorkService.request(SeriesRequest(limit: limit, offset: offset, characterId: characterId)) { result in
            switch result {
            case .success(let series):
                completion(.success(series.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

}
