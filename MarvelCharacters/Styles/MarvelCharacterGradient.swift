//
//  MarvelCharacterGradient.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 21/4/22.
//

import UIKit

public extension UIView {

    /// Set gradient background view
    /// - Parameters:
    ///   - colors: array of colors to gradient.
    ///   - startPoint: gradient start place on screen.
    ///   - endPoint: gradient end place on screen
    func addGradient(colors: [UIColor] = [.blueColor, .whiteColor], startPoint: CGPoint = CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0)) {

        let gradient = CAGradientLayer()

        gradient.frame.size = self.frame.size
        gradient.frame.origin = CGPoint(x: 0.0, y: 0.0)

        gradient.colors = colors.map { $0.cgColor }

        gradient.startPoint = startPoint
        gradient.endPoint = endPoint

        self.layer.insertSublayer(gradient, at: 0)
    }
}
