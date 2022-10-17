//
//  AppConfigurationTests.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 17/10/22.
//

import XCTest
@testable import MarvelCharacters

class AppConfigurationTests: XCTestCase {

    let appConfiguration = AppConfiguration()

    func testCheckApiKeys() {
        if appConfiguration.publicKey == "" || appConfiguration.privateKey == "" {
            XCTAssertEqual(appConfiguration.checkApiKeys(), false)
        } else {
            XCTAssertEqual(appConfiguration.checkApiKeys(), true)
        }

    }

}
