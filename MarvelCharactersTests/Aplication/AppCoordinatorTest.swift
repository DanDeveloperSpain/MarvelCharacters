//
//  AppCoordinatorTest.swift
//  MarvelCharactersTests
//
//  Created by Daniel Pérez Parreño on 21/4/22.
//

import XCTest
@testable import MarvelCharacters

class AppCoordinatorTest: XCTestCase {

    var appCoordinator: AppCoordinator?

    override func setUp() {
        let navigationController = UINavigationController()

        appCoordinator = AppCoordinator.init(navigationController)
    }

    func testCoodinator() {
        appCoordinator?.start()

        guard (appCoordinator?.childCoordinators[0] as? LoginCoordinator) != nil else {
            XCTFail("fail child appCoordinator")
            return
        }
    }

}
