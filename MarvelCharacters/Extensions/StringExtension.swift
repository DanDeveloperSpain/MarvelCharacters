//
//  StringExtension.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 9/11/22.
//

import Foundation

extension String {

    func toDate(dateFormat: dateFormat) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.description
        return dateFormatter.date(from: self.identity) ?? Date()
    }
}
