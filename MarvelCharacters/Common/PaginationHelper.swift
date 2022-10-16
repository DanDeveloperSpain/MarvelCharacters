//
//  PaginationHelper.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 2/6/22.
//

import Foundation

struct PaginationHelper {

    /// Check if there is more data to request the Api.
    /// - Parameters:
    ///   - offset: exclude results.
    ///   - total: total results.
    ///   - limit: limit of the results.
    /// - Returns: True if there is more data to request.
    static func isMoreDataToLoad(offset: Int, total: Int, limit: Int) -> Bool {
        if offset == 0 {
            return limit <= total ? true : false
        } else {
            return offset <= total ? true : false
        }
    }

    /// Helper to know the last item shown and to know if it is the last one to make the next request.
    /// - Parameters:
    ///   - offset: exclude results.
    ///   - characters: number of current results getted.
    /// - Returns: Number of the current item shown.
    static func numLastItemToShow(offset: Int, all: Int) -> Int {
        return offset + all - 1
    }
}
