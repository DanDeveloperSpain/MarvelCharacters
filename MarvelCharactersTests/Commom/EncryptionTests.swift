//
//  EncryptionTests.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 20/10/22.
//

import XCTest
@testable import MarvelCharacters

class EncryptionTests: XCTestCase {

    func testEncryption_md5Hash() {
        let resultTestHas = "098f6bcd4621d373cade4e832627b4f6"
        let testHas = Encryption.md5Hash("test")
        XCTAssertEqual(testHas, resultTestHas)
    }

}
