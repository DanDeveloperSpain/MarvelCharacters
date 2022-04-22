//
//  MarvelCharacterButton.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 21/4/22.
//

import UIKit

public extension UIButton {

    func configure(text: String, font: MarvelCharacterFontStyle.FontsWithSize = .boldMedium, width: CGFloat = 100, height: CGFloat = 40) {

        self.backgroundColor = .whiteColor

        /// text
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font.get() ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.blackColor])
        self.setAttributedTitle(attributedText, for: .normal)

        /// shadow
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 6
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.blackColor.cgColor

        /// size
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height)

        ])
        self.layer.cornerRadius = height/2
    }

}
