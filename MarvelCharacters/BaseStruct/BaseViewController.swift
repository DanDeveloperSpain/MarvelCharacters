//
//  BaseViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/10/21.
//

import UIKit
import DanDesignSystem

protocol BaseViewControllerProtocol {

    /// UI Setup
    func setup()

    /// Here others importans methos for life cyle (Localizationes, identifiers for test, ...)
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {

    var baseViewModel: BaseViewModel?

    // ---------------------------------
    // MARK: - Init
    // ---------------------------------

    init(nibName: String? = nil, bundle: Bundle? = nil, viewModel: BaseViewModel) {
        super.init(nibName: nibName, bundle: bundle)
        self.baseViewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // ---------------------------------
    // MARK: - Life Cycle
    // ---------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialization
        setup()
        baseViewModel?.start()
    }

    /// Public methods to implement
    func setup() {
        preconditionFailure("Implement it in ViewController")
    }

    // ---------------------------------
    // MARK: - Setup NavigationBar
    // ---------------------------------

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
        myBackButton.addTarget(self, action: #selector(self.pop(_:)), for: UIControl.Event.touchUpInside)
        myBackButton.setImage(DSImage(named: .icon_backButton)?.withTintColor(.dsWhite), for: .normal)
        myBackButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        myBackButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: -15, bottom: 5, right: 5)
        let myCustomBackButtonItem: UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = myCustomBackButtonItem
    }

    @objc private func pop(_ sender: AnyObject) {

        self.backButtonPressed()

        if self.navigationController?.popViewController(animated: true) != nil {
            /// Has been closed successfully
        } else {
            if self.navigationController?.parent == nil {
                /// We make sure that it can always be closed
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    /// Actions before closing (overwritten in controller)
    @objc func backButtonPressed() {
    }

    // ---------------------------------
    // MARK: - Public methods
    // ---------------------------------

    func showDialogModal(dialogViewController: DialogViewController) {
        self.present(dialogViewController, animated: true, completion: nil)
    }

}
