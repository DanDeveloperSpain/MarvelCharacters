//
//  TabBarViewSettings.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import UIKit

enum TabBarPage {
    case home
    case user
    case dsDemo

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .user
        case 2:
            self = .dsDemo
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
        case .dsDemo:
            return "DSDemo"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .user:
            return 1
        case .dsDemo:
            return 2
        }
    }

    func pageImage() -> UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill") ?? UIImage()
        case .user:
            return UIImage(systemName: "person.fill") ?? UIImage()
        case .dsDemo:
            return UIImage(systemName: "gearshape.fill") ?? UIImage()
        }

    }
}
