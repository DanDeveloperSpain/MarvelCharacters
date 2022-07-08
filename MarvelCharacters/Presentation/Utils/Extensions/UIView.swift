//
//  ExtView.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 8/7/22.
//

import UIKit

extension UIView {

    func setBackgroundImage(imageName: String) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.contentMode = .scaleAspectFill
        self.insertSubview(backgroundImage, at: 0)
    }
}
