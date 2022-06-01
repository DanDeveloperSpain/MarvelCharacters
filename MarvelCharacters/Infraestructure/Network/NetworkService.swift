//
//  NetworkService.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 31/5/22.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

final class DefaultNetworkService: NetworkServiceProtocol {

    // ARREGLAR DEPENDENCIA
    private let logger = DefaultNetworkErrorLogger()

    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {

        guard var urlComponent = URLComponents(string: request.url) else {
            let error = NSError(domain: ErrorResponse.invalidEndpoint.rawValue, code: 404, userInfo: nil)
            return completion(.failure(error))
        }

        var queryItems: [URLQueryItem] = []

        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }

        urlComponent.queryItems = queryItems

        guard let url = urlComponent.url else {
            let error = NSError(domain: ErrorResponse.invalidEndpoint.rawValue, code: 404, userInfo: nil)
            return completion(.failure(error))
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        URLSession.shared.configuration.timeoutIntervalForRequest = 30.0
        URLSession.shared.configuration.timeoutIntervalForResource = 60.0

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error ) in

            self.logger.log(request: urlRequest)

            if let error = error {
                self.logger.log(error: error)
                return completion(.failure(error))
            }

            guard let response = response as? HTTPURLResponse, 200..<300 ~=  response.statusCode else {
                self.logger.log(responseData: Data(), response: response)
                return completion(.failure(NSError()))
            }

            guard let data = data else {
                self.logger.log(responseData: data, response: response)
                return completion(.failure(NSError()))
            }

            do {
                let decodedData = try request.decode(data)
                completion(.success(decodedData))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()

    }
}
