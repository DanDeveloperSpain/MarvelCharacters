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
    /// - Returns: True if there is more data to request.
    static func isMoreDataToLoad(offset: Int, total: Int) -> Bool {
        return offset < total ? true : false
    }

    /// Helper to know the last item shown and to know if it is the last one to make the next request.
    /// - Parameters:
    ///   - offset: exclude results.
    /// - Returns: Number of the current item shown.
    static func numLastItemToShow(offset: Int) -> Int {
        return offset - 1
    }
}
