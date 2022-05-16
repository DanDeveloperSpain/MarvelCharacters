//
//  CheckboxViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 15/5/22.
//

import UIKit
import DanDesignSystem

class CheckboxViewController: UIViewController {

    // ---------------------------------
    // MARK: - Outlets
    // ---------------------------------

    @IBOutlet weak var stackView: UIStackView!

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private var checkboxViews: [CheckboxView] = []

    private var checkboxActiveView: CheckboxView?
    private var checkboxFocusView: CheckboxView?
    private var checkboxSelectedView: CheckboxView?
    private var checkboxDisabledView: CheckboxView?
    private var checkboxDisabledSelectedView: CheckboxView?
    private var checkboxLinkView: CheckboxView?

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        title = "Checkbox"

        checkboxActiveView = CheckboxView.instance(state: .active, id: 1, title: "Active", subTitle: "Subtitle optional", delegate: self)
        checkboxFocusView = CheckboxView.instance(state: .focus, id: 2, title: "Focus", delegate: self)
        checkboxSelectedView = CheckboxView.instance(state: .selected, id: 3, title: "Selected", subTitle: "Subtitle optional", delegate: self)
        checkboxDisabledView = CheckboxView.instance(state: .disabled, id: 4, title: "Disabled", delegate: self)
        checkboxDisabledSelectedView = CheckboxView.instance(state: .disabledSelected, id: 5, title: "DisabledSelected", subTitle: "Subtitle optional", delegate: self)
        checkboxLinkView = CheckboxView.instance(state: .active, id: 6, title: "Interaction Link", titleSize: .small, isLinkInteraction: true, delegate: self)

        checkboxViews.append(checkboxActiveView ?? CheckboxView())
        checkboxViews.append(checkboxFocusView ?? CheckboxView())
        checkboxViews.append(checkboxSelectedView ?? CheckboxView())
        checkboxViews.append(checkboxDisabledView ?? CheckboxView())
        checkboxViews.append(checkboxDisabledSelectedView ?? CheckboxView())
        checkboxViews.append(checkboxLinkView ?? CheckboxView())

        checkboxViews.forEach {(view) in
            stackView.addArrangedSubview(view)
        }

    }

    private func resetCheckboxDeselected(deselectedCheckboxView: CheckboxView) {
        switch deselectedCheckboxView.id {
        case 1:
            deselectedCheckboxView.configure(title: "Active", subTitle: "Subtitle optional")
        case 2:
            deselectedCheckboxView.focus()
            deselectedCheckboxView.configure(title: "Focus")
        case 3:
            deselectedCheckboxView.configure(title: "Active", subTitle: "Subtitle optional")
        case 6:
            deselectedCheckboxView.configure(title: "Interaction Link", subTitle: "Subtitle optional")
        default:
            break
        }
    }

}

// ---------------------------------
// MARK: - CheckboxViewDelegate
// ---------------------------------
extension CheckboxViewController: CheckboxViewDelegate {

    func checkboxViewSelected(view: CheckboxView) {
        view.configure(title: "Selected")
    }

    func checkboxViewDeselected(view: CheckboxView) {
        resetCheckboxDeselected(deselectedCheckboxView: view)
    }

    func checkboxViewLinkPressed(view: CheckboxView) {
        print("Link pressed")
    }

}
