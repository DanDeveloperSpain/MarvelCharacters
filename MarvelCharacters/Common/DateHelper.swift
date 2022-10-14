//
//  DateHelper.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 14/10/22.
//

import Foundation

struct DateHelper {

    static func stringDateToShortDate(dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateStyle = .medium

        if let date = dateFormatterGet.date(from: dateString) {
            return dateFormatterPrint.string(from: date)
        } else {
            return ""
        }
    }

}
