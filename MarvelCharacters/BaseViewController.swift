//
//  BaseViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/10/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    func setupNavigationBar(title: String?) {
        self.title = title
        self.customizeLeftNavBarButton()
    }
    
    private func customizeLeftNavBarButton () {
        let myBackButton = UIButton(type: UIButton.ButtonType.custom)
        myBackButton.addTarget(self, action: #selector(self.pop(_:)), for: UIControl.Event.touchUpInside)
        myBackButton.setImage(UIImage(named: "backButtonBlack"), for: .normal)
        myBackButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        myBackButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: -15, bottom: 5, right: 5)
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = myCustomBackButtonItem
    }
    
    // MARK: - Button actions
    
    @objc private func pop(_ sender: AnyObject) {

        self.backButtonPressed()
        
        if self.navigationController?.popViewController(animated: true) != nil {
            // Se ha cerrado correctamente
        } else {
            if(self.navigationController?.parent == nil) {
                // HACK: Nos aseguramos que siempre se puede cerrar
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @objc func backButtonPressed() {
        // Acciones antes de cerrar (sobreescrita en el controlador)
    }
    
}
