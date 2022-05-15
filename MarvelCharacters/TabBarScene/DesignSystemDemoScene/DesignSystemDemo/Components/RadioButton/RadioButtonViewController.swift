//
//  RadioButtonViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 15/5/22.
//

import UIKit
import DanDesignSystem

class RadioButtonViewController: UIViewController {

    // ---------------------------------
    // MARK: - Outlets
    // ---------------------------------

    @IBOutlet weak var stackView: UIStackView!

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private var radioButtonViews: [RadioButtonView] = []

    private var radioButtonActiveView: RadioButtonView?
    private var radioButtonFocusView: RadioButtonView?
    private var radioButtonSelectedView: RadioButtonView?
    private var radioButtonDisabledView: RadioButtonView?
    private var radioButtonDisabledSelectedView: RadioButtonView?

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        title = "Radio Buttons"

        radioButtonActiveView = RadioButtonView.instance(state: .active, size: .large, id: 1, title: "Active", subTitle: "Subtitle optional", delegate: self)
        radioButtonFocusView = RadioButtonView.instance(state: .focus, size: .large, id: 2, title: "Focus", delegate: self)
        radioButtonSelectedView = RadioButtonView.instance(state: .selected, size: .large, id: 3, title: "Selected", subTitle: "Subtitle optional", delegate: self)
        radioButtonDisabledView = RadioButtonView.instance(state: .disabled, size: .large, id: 4, title: "Disabled", delegate: self)
        radioButtonDisabledSelectedView = RadioButtonView.instance(state: .disabledSelected, size: .large, id: 5, title: "DisabledSelected", subTitle: "Subtitle optional", delegate: self)

        radioButtonViews.append(radioButtonActiveView ?? RadioButtonView())
        radioButtonViews.append(radioButtonFocusView ?? RadioButtonView())
        radioButtonViews.append(radioButtonSelectedView ?? RadioButtonView())
        radioButtonViews.append(radioButtonDisabledView ?? RadioButtonView())
        radioButtonViews.append(radioButtonDisabledSelectedView ?? RadioButtonView())

        radioButtonViews.forEach {(view) in
            stackView.addArrangedSubview(view)
        }

    }

    private func disabledAllSelectedRadioButtonViewsForDemo(radioButtonViews: [RadioButtonView], selectedView: RadioButtonView) {
        radioButtonViews.forEach {(view) in
            if view.state == .selected && view != selectedView {
                view.configure(title: "Active")
                view.active()
            }
        }
    }

}

// ---------------------------------
// MARK: - RadioButtonViewDelegate
// ---------------------------------
extension RadioButtonViewController: RadioButtonViewDelegate {

    func radioButtonViewOnClick(view: RadioButtonView) {
        view.configure(title: "Selected")
        disabledAllSelectedRadioButtonViewsForDemo(radioButtonViews: radioButtonViews, selectedView: view)
    }

}
