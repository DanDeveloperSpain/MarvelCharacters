//
//  LoginViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//

import UIKit

class LoginViewController: UIViewController {

    var didSendEventClosure: ((LoginViewController.Event) -> Void)?

    override func viewDidLoad() {
        view.backgroundColor = .white
    }

    deinit {
        print("LoginViewController deinit")
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        didSendEventClosure?(.login)
        
    }

    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        didSendEventClosure?(.createAccount)
    }

}

extension LoginViewController {
    enum Event {
        case login, createAccount
    }

}
