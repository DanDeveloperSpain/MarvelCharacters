//
//  DateFormat.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 9/11/22.
//

import Foundation

enum dateFormat: String {
    case long
    case short
    case shortWhitDate
    case extraLong
    case year

    var description: String {
        switch self {
        case .long:
            return "EEEE,-MMM-d,-yyyy"
        case .short:
            return "MMM d, yyyy"
        case .shortWhitDate:
            return "MM-dd-yvyy-HH:mm"
        case .extraLong:
            return "yyyy-MM-dd'T'HH:mm:ssz"
        case .year:
            return "yyyy"
        }
    }
}
