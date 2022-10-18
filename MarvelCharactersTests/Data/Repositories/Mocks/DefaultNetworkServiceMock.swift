//
//  DefaultNetworkServiceMock.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 18/10/22.
//

import Foundation
@testable import MarvelCharacters

final class DefaultNetworkServiceMock: NetworkServiceProtocol {

    var logger: DefaultNetworkErrorLogger

    var apiDataNetworkConfig: NetworkConfigurable

    init(apiDataNetworkConfig: ApiDataNetworkConfig) {
        self.apiDataNetworkConfig = apiDataNetworkConfig
        self.logger = DefaultNetworkErrorLogger()
    }

    func request<Request>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) where Request: DataRequest {

        // Use baseURL for get CharactersMock, ComicsMock, SeriesMock or send error.

        if apiDataNetworkConfig.baseURL != "" {
            do {
                var data = Data()
                if let url = Bundle(for: type(of: self)).url(forResource: apiDataNetworkConfig.baseURL, withExtension: "json") {
                    data = try Data(contentsOf: url)
                    let decodedData = try request.decode(data)
                    completion(.success(decodedData))
                }
            } catch {
            }
        } else {
            let error = NSError(domain: ErrorResponse.invalidEndpoint.description, code: 404, userInfo: nil)
            return completion(.failure(error))
        }

    }

}
