//
//  TabBarViewSettings.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import Foundation

enum TabBarPage {
    case home
    case user

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .user
        default:
            return nil
        }
    }

    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "Home"
        case .user:
            return "User"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .user:
            return 1
        }
    }

    // Add tab icon value

    // Add tab icon selected / deselected color

    // etc
}
