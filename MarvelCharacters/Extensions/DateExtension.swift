//
//  DateExtension.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 9/11/22.
//

import Foundation

extension Date {

    func toString(dateFormat: dateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.description
        return dateFormatter.string(from: self)
    }
}
