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

    func fetchCharcters(limit: Int, offset: Int) -> Observable<ResponseCharacters> {

        return Observable.create { observer in

            // DataBase Cache here
            // let responseCharactersDatabase = ResponseCharacters(total: 300, characters: [])
            // observer.onNext(responseCharactersDatabase)

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

    private func fetchCharactersFromNetwork(limit: Int, offset: Int, complete completion: @escaping (Result<ResponseCharacters, Error>) -> Void) {
        netWorkService.request(CharactersRequest(limit: limit, offset: offset)) { result in
            switch result {
            case .success(let characters):
                completion(.success(ResponseCharacters(from: characters.data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

}

// MARK: - Mappers

private extension ResponseCharacters {

    init(from characterDataContainer: CharacterDataContainer) {
        self.total = characterDataContainer.total
        self.characters = characterDataContainer.results?.compactMap({ Character(from: $0)})
    }
}

private extension Character {

    init(from characterData: CharacterData) {
        self.id = characterData.id
        self.name = characterData.name
        self.description = characterData.description
        self.imageUrl = "\(characterData.thumbnail?.path ?? "").\(characterData.thumbnail?.typeExtension ?? "")"
    }
}
