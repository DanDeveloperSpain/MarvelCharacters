//
//  DateHelperTests.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 20/10/22.
//

import XCTest
@testable import MarvelCharacters

class DateHelperTests: XCTestCase {

    let mainDateToTest = "2018-09-12T14:11:54+0000"

    func testStringDateToDate() {
        var dateComponents = DateComponents()
        dateComponents.year = 2018
        dateComponents.month = 9
        dateComponents.day = 12
        dateComponents.hour = 16
        dateComponents.minute = 11
        dateComponents.second = 54

        let userCalendar = Calendar(identifier: .gregorian)
        let resultDate = userCalendar.date(from: dateComponents)

        let date = DateHelper.stringDateToDate(dateString: mainDateToTest)
        XCTAssertEqual(date, resultDate)
    }

    func testStringDateToYear() {
        let date = DateHelper.stringDateToDate(dateString: mainDateToTest)
        let resultYear = DateHelper.dateToYear(date: date)
        XCTAssertEqual(resultYear, "2018")
    }

    func testStringDateToShortDate() {
        let date = DateHelper.stringDateToDate(dateString: mainDateToTest)
        let resultShortDate = DateHelper.dateToShortDate(date: date)
        XCTAssertEqual(resultShortDate, "sep. 12, 2018")
    }

}
