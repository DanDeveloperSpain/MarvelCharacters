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

    func fetchCharcters(characterId: String, limit: Int, offset: Int) -> Observable<ResponseComics> {

        // DataBase Cache here

        return Observable.create { observer in
            self.fetchComicsFromNetwork(characterId: characterId, limit: limit, offset: offset ) { result in
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

    /// Request comics by character data to Api.
    /// - Parameters:
    ///   - characterId: Id of the character to search for their comics.
    ///   - limit: limit of the results.
    ///   - offset: exclude results.
    /// - Returns: Comics of the character or error
    private func fetchComicsFromNetwork(characterId: String, limit: Int, offset: Int, complete completion: @escaping (Result<ResponseComics, Error>) -> Void) {
        netWorkService.request(ComicsRequest(characterId: characterId, limit: limit, offset: offset)) { result in
            switch result {
            case .success(let comics):
                completion(.success(ResponseComics(from: comics.data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

}

// MARK: - Mappers

private extension ResponseComics {

    init(from comicDataContainer: ComicDataContainer) {
        self.offset = comicDataContainer.offset
        self.total = comicDataContainer.total
        self.comics = comicDataContainer.results?.compactMap({ Comic(from: $0)})
    }
}

private extension Comic {

    init(from comicData: ComicData) {
        self.id = comicData.id
        self.title = comicData.title
        self.imageUrl = "\(comicData.thumbnail?.path ?? "").\(comicData.thumbnail?.typeExtension ?? "")"

        self.startDate = {
            if let onsaleDate = comicData.dates?.filter({$0.type == "onsaleDate"}).first {
                return DateHelper.stringDateToShortDate(dateString: onsaleDate.date ?? "")
            } else {
                return ""
            }
        }()
    }

}
