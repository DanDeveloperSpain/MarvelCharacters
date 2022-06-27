//
//  NetworkService.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 31/5/22.
//

import Foundation

protocol NetworkServiceProtocol {
    var logger: DefaultNetworkErrorLogger { get }
    var apiDataNetworkConfig: NetworkConfigurable { get }
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

final class DefaultNetworkService: NetworkServiceProtocol {

    var logger: DefaultNetworkErrorLogger
    var apiDataNetworkConfig: NetworkConfigurable

    public init(apiDataNetworkConfig: NetworkConfigurable, logger: DefaultNetworkErrorLogger) {
        self.apiDataNetworkConfig = apiDataNetworkConfig
        self.logger = logger
    }

    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {

        guard var urlComponent = URLComponents(string: apiDataNetworkConfig.baseURL + request.path) else {
            let error = NSError(domain: ErrorResponse.invalidEndpoint.rawValue, code: 404, userInfo: nil)
            return completion(.failure(error))
        }

        // QueryItems
        urlComponent.queryItems = setQueryItems(request: request, apiDataNetworkConfig: apiDataNetworkConfig)

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
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    let error = NSError(domain: ErrorResponse.invalidEndpoint.description, code: statusCode, userInfo: nil)
                    return completion(.failure(error))
                } else {
                    let error = NSError(domain: ErrorResponse.apiError.description, code: 400, userInfo: nil)
                    return completion(.failure(error))
                }
            }

            guard let data = data else {
                self.logger.log(responseData: data, response: response)
                let error = NSError(domain: ErrorResponse.noData.rawValue, code: response.statusCode, userInfo: nil)
                return completion(.failure(error))
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

extension DefaultNetworkService {

    func setQueryItems<Request: DataRequest>(request: Request, apiDataNetworkConfig: NetworkConfigurable) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []

        apiDataNetworkConfig.baseQueryItems?.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            queryItems.append(urlQueryItem)
        }

        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            queryItems.append(urlQueryItem)
        }

        return queryItems
    }

}
