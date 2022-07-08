//
//  Modable.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 6/7/22.
//

import UIKit
import DanDesignSystem

public protocol Modable {}

public extension Modable where Self: UIViewController {

    func showDialogModal(image: UIImage, title: String, titlePrimaryButton: String, delegate: DialogViewControllerDelegate) {
        let dialogModal = DialogViewController(image: image, title: title, titlePrimaryButton: titlePrimaryButton, delegate: delegate)
        self.present(dialogModal, animated: true, completion: nil)
    }

}
