//
//  NetworkErrorLogger.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 31/5/22.
//

import Foundation

protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?)
    func log(response: URLResponse?)
    func log(error: Error)
}

final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    init() { }

    func log(request: URLRequest) {
        printIfDebug("——————————————————————————————")
        printIfDebug("ℹ️ request: \(request.url!)")
        printIfDebug("ℹ️ headers: \(request.allHTTPHeaderFields!)")
        printIfDebug("ℹ️ method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    func log(responseData data: Data?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("🧨 Error responseData: \(String(describing: dataDict))")
        }
    }

    func log(response: URLResponse?) {
        if let httpResponse = response as? HTTPURLResponse {
            printIfDebug("🧨 Error statusCode: \(httpResponse.statusCode)")
        }
    }

    func log(error: Error) {
        printIfDebug("🧨 Error request" + "\(error)")
    }

    func printIfDebug(_ string: String) {
        #if DEBUG
        debugPrint(string)
        #endif
    }
}
