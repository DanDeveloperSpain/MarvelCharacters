//
//  MarvelCharacterLabel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 4/10/21.
//

import UIKit

public extension UILabel {
    
    /// Set a label and add the style to it.
    /// - Parameters:
    ///   - text: text to show
    ///   - font: type font (font and size)
    ///   - color: color of the text
    func configure(with text: String? = nil, font: MarvelCharacterFontStyle.fontsWithSize, color: UIColor = UIColor.blackColor) {
        self.text = text ?? ""
        self.font = font.get()
        self.textColor = color
    }
}

public final class MarvelCharacterFontStyle {
    
    public enum fontsWithSize {
        case boldSmall
        case boldMedium
        case boldLarge
        case semiboldSmall
        case semiboldMedium
        case semiboldLarge
        
        public func get() -> UIFont? {
            switch self {
            case .boldSmall:
                return UIFont.systemFont(ofSize: 14.0, weight: .bold)
            case .boldMedium:
                return UIFont.systemFont(ofSize: 16.0, weight: .bold)
            case .boldLarge:
                return UIFont.systemFont(ofSize: 18.0, weight: .bold)
            case .semiboldSmall:
                return UIFont.systemFont(ofSize: 14.0, weight: .semibold)
            case .semiboldMedium:
                return UIFont.systemFont(ofSize: 16.0, weight: .semibold)
            case .semiboldLarge:
                return UIFont.systemFont(ofSize: 18.0, weight: .semibold)
            }
        }
    }
    
}

