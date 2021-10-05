//
//  BaseRouter.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/10/21.
//

import Foundation
import UIKit

class BaseRouter {
    init() { }
    
    weak var viewController : UIViewController!
    
    func navigate(toViewController vc: UIViewController) {
        if let nc = viewController?.navigationController {
            nc.show(vc, sender: nil)
        } else {
            viewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func showSimpleAlertAccept(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Accept", comment: ""), style: UIAlertAction.Style.cancel, handler: nil))
        alert.view.tintColor = .principalColor
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func pop() {
        if let nc = viewController?.navigationController {
            nc.popViewController(animated: true)
        } else {
            dismiss()
        }
    }
    
    @objc private func dismiss(animated: Bool = true) {
        viewController?.dismiss(animated: animated, completion: nil)
    }
    
}
