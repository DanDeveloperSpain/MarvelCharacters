//
//  CharactersRepository.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 31/5/22.
//

import Foundation
import RxSwift

final class CharactersRepository {

    private let netWorkService: NetworkServiceProtocol
    // private let chache: CharacterResponseStorage

    init(netWorkService: NetworkServiceProtocol) {
        self.netWorkService = netWorkService
    }

}

extension CharactersRepository: CharactersRepositoryProtocol {

    func fetchCharcters(limit: Int, offset: Int) -> Observable<ResponseCharactersData> {

        // DataBase Cache

        return Observable.create { observer in
            self.fetchCharactersFromNetwork(limit: limit, offset: offset) { result in
                switch result {
                case .success(let responseCharactersData):
                    observer.onNext(responseCharactersData)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    private func fetchCharactersFromNetwork(limit: Int, offset: Int, complete completion: @escaping (Result<ResponseCharactersData, Error>) -> Void) {
        netWorkService.request(CharactersRequest(limit: limit, offset: offset)) { result in
            switch result {
            case .success(let characters):
                completion(.success(characters.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

}
