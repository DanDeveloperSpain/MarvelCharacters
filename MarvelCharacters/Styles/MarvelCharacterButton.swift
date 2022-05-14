//
//  MarvelCharacterButton.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 21/4/22.
//

import UIKit
import DanDesignSystem

public extension UIButton {

    /// Configure styles buttons
    /// - Parameters:
    ///   - text: text of the button.
    ///   - font: font to text.
    ///   - width: width button constraint.
    ///   - height: height button constraint.
    func configure(text: String, font: Typography.FontsWithSize = .boldMedium, width: CGFloat = 100, height: CGFloat = 40) {

        self.backgroundColor = .dsWhite

        /// text
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font.get() ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.dsBlack])
        self.setAttributedTitle(attributedText, for: .normal)

        /// shadow
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 6
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.dsBlack.cgColor

        /// size
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height)

        ])
        self.layer.cornerRadius = height/2
    }

}
