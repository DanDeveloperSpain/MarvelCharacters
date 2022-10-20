//
//  DateHelper.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 14/10/22.
//

import Foundation

struct DateHelper {

    static func stringDateToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateString) ?? Date()
    }

    static func dateToYear(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }

    static func dateToShortDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }

}
