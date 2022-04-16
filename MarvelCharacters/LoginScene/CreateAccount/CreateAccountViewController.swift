//
//  CreateAccountViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import UIKit

class CreateAccountViewController: UIViewController {

    var didSendEventClosure: ((CreateAccountViewController.Event) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        print("ForgotPasswordViewController deinit")
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        didSendEventClosure?(.closeButton)
    }
}

extension CreateAccountViewController {
    enum Event {
        case closeButton
    }
}
