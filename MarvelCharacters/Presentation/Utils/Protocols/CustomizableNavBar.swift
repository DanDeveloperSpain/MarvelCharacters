//
//  CustomizableNavBar.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 7/7/22.
//

import UIKit
import DanDesignSystem

public protocol CustomizableNavBar {}

public extension CustomizableNavBar where Self: UIViewController {

    func setupNavigationBar(title: String?, color: UIColor, configureBackButton: Bool = false) {
        navigationItem.title = title
        self.customizeNavBar(color: color)
        if configureBackButton {
            self.customizeLeftNavBarButton()
        }
    }

    private func customizeNavBar(color: UIColor) {
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: Typography.FontsWithSize.boldLarge.get() ?? UIFont.systemFont(ofSize: 18.0, weight: .bold), NSAttributedString.Key.foregroundColor: color]
    }

    private func customizeLeftNavBarButton () {
        let myBackButton = UIButton(type: UIButton.ButtonType.custom)
        myBackButton.addTarget(self, action: #selector(self.backButtonPressed111(_:)), for: UIControl.Event.touchUpInside)
        myBackButton.setImage(DSImage(named: .icon_backButton)?.withTintColor(.dsWhite), for: .normal)
        myBackButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        myBackButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: -15, bottom: 5, right: 5)
        let myCustomBackButtonItem: UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = myCustomBackButtonItem
    }

}

fileprivate extension UIViewController {

    /// Actions before closing (overwritten in controller)
    @objc func backButtonPressed111(_ sender: AnyObject) {
        print("____****")
    }
}
