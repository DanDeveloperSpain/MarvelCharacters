//
//  MarvelCharacterGradient.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 21/4/22.
//

import UIKit

public extension UIView {
    
    func addGradient(colors: [UIColor] = [.blueColor, .whiteColor], locations: [NSNumber] = [0, 1], startPoint: CGPoint = CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0), type: CAGradientLayerType = .axial){
        
        let gradient = CAGradientLayer()
        
        gradient.frame.size = self.frame.size
        gradient.frame.origin = CGPoint(x: 0.0, y: 0.0)

        gradient.colors = colors.map{ $0.cgColor }
        
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        
        self.layer.insertSublayer(gradient, at: 0)
    }
}
