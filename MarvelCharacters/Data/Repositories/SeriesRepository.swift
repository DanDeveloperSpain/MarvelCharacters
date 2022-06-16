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

    func fetchCharcters(characterId: String, limit: Int, offset: Int) -> Observable<ResponseSeriesData> {

        // DataBase Cache

        return Observable.create { observer in
            self.fetchSeriesFromNetwork(characterId: characterId, limit: limit, offset: offset) { result in
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

    /// Request series by character data to Api.
    /// - Parameters:
    ///   - characterId: Id of the character to search for their series.
    ///   - limit: limit of the results.
    ///   - offset: exclude results
    /// - Returns: Series of the character or error
    private func fetchSeriesFromNetwork(characterId: String, limit: Int, offset: Int, complete completion: @escaping (Result<ResponseSeriesData, Error>) -> Void) {
        netWorkService.request(SeriesRequest(characterId: characterId, limit: limit, offset: offset)) { result in
            switch result {
            case .success(let series):
                completion(.success(series.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

}
