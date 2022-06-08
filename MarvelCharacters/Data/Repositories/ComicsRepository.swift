//
//  ComicsRepository.swift
//  MarvelComics
//
//  Created by Daniel Pérez Parreño on 3/6/22.
//

import Foundation
import RxSwift

final class ComicsRepository {

    private let netWorkService: NetworkServiceProtocol
    // private let chache: CharacterResponseStorage

    init(netWorkService: NetworkServiceProtocol) {
        self.netWorkService = netWorkService
    }

}

extension ComicsRepository: ComicsRepositoryProtocol {

    func fetchCharcters(limit: Int, offset: Int, characterId: String) -> Observable<ResponseComicsData> {

        // DataBase Cache

        return Observable.create { observer in
            self.fetchComicsFromNetwork(limit: limit, offset: offset, characterId: characterId) { result in
                switch result {
                case .success(let responseComicsData):
                    observer.onNext(responseComicsData)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    private func fetchComicsFromNetwork(limit: Int, offset: Int, characterId: String, complete completion: @escaping (Result<ResponseComicsData, Error>) -> Void) {
        netWorkService.request(ComicsRequest(limit: limit, offset: offset, characterId: characterId)) { result in
            switch result {
            case .success(let comics):
                completion(.success(comics.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

}
