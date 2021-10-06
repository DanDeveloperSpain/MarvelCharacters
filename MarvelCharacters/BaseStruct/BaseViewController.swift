//
//  BaseViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/10/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    var _viewModel: BaseViewModel?
    
    init(nibName: String? = nil, bundle: Bundle? = nil, viewModel: BaseViewModel) {
        super.init(nibName: nibName, bundle: bundle)
        self._viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: MarvelCharacterFontStyle.fontsWithSize.boldLarge.get() ?? UIFont.systemFont(ofSize: 18.0, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.whiteColor]
        
        // Initialization
        setup()
        _viewModel?.loadView()
    }
    
    /// Public methods to implement
    func setup() {
        preconditionFailure("Implement it in ViewController")
    }
    
    /// Setup NavigationBar
    func setupNavigationBar(title: String?) {
        self.title = title
        self.customizeLeftNavBarButton()
    }
    
    private func customizeLeftNavBarButton () {
        let myBackButton = UIButton(type: UIButton.ButtonType.custom)
        myBackButton.addTarget(self, action: #selector(self.pop(_:)), for: UIControl.Event.touchUpInside)
        myBackButton.setImage(UIImage(named: "backButton")?.withTintColor(.white), for: .normal)
        myBackButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        myBackButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: -15, bottom: 5, right: 5)
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = myCustomBackButtonItem
    }
    
    @objc private func pop(_ sender: AnyObject) {

        self.backButtonPressed()
        
        if self.navigationController?.popViewController(animated: true) != nil {
            /// Has been closed successfully
        } else {
            if(self.navigationController?.parent == nil) {
                /// We make sure that it can always be closed
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    /// Actions before closing (overwritten in controller)
    @objc func backButtonPressed() {
    }
    
}
