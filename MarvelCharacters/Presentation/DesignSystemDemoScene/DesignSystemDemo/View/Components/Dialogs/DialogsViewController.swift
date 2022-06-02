//
//  DialogsViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 15/5/22.
//

import UIKit
import DanDesignSystem

class DialogsViewController: UIViewController {

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private var dialogModal: DialogViewController?
    private var dialogModalNoImage: DialogViewController?
    private var dialogFullScreen: DialogViewController?

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        title = "Dialog"

        dialogModal = DialogViewController(image: DSImage(named: .icon_info) ?? UIImage(), title: "Dialog title two lines max for description", subtitle: "Description body, all the lines that are needed, although it is recommended not to exceed 3.", titlePrimaryButton: "Primary action", titleSecondaryButton: "Secondary action", fullScreen: false, hideCloseButton: false, delegate: self)

        dialogModalNoImage = DialogViewController(title: "Dialog title two lines max for description", subtitle: "Description body, all the lines that are needed, although it is recommended not to exceed 3.", titlePrimaryButton: "Primary action", titleSecondaryButton: "Secondary action", fullScreen: false, delegate: self)

        dialogFullScreen = DialogViewController(image: DSImage(named: .icon_info) ?? UIImage(), title: "Dialog title two lines max for description", titlePrimaryButton: "Primary action", fullScreen: true, hideCloseButton: false, delegate: self)
    }

    // ---------------------------------
    // MARK: - Button Action`s
    // ---------------------------------

    @IBAction func showModalButtonPressed(_ sender: UIButton) {
        self.present(dialogModal ?? UIViewController(), animated: true, completion: nil)
    }

    @IBAction func showModalNoImagePressed(_ sender: UIButton) {
        self.present(dialogModalNoImage ?? UIViewController(), animated: true, completion: nil)
    }

    @IBAction func showFullScreenButtonPressed(_ sender: UIButton) {
        self.present(dialogFullScreen ?? UIViewController(), animated: true, completion: nil)
    }
}

// ---------------------------------
// MARK: - DialogButtonViewDelegate
// ---------------------------------

extension DialogsViewController: DialogViewControllerDelegate {

    func tapPrincipalButton() {
        print("tap 1")
    }

    func tapSecondaryButton() {
        print("tap 2")
    }

    func tapCloseButton() {
        print("close")
    }

}
