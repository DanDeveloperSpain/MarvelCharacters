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

    override func setUp() {

    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheckApiKeys() {
        if appConfiguration.publicKey == "" || appConfiguration.privateKey == "" {
            XCTAssertEqual(appConfiguration.checkApiKeys(), false)
        } else {
            XCTAssertEqual(appConfiguration.checkApiKeys(), true)
        }

    }

}
