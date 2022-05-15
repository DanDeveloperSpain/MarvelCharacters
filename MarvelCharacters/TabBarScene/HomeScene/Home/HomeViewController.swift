//
//  HomeViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 29/9/21.
//

import UIKit
import SwiftUI
import DanDesignSystem

final class HomeViewController: BaseViewController {

    // ------------------------------------------------
    // MARK: - Outlets
    // ------------------------------------------------

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var tryAgainButton: UIButton!

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    /// Set the model of the view.
    private var viewModel: HomeViewModel? {
        return self.baseViewModel as? HomeViewModel
    }

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    /// Setup the view.
    override internal func setup() {
        viewModel?.setView(self)
        configureView()
        configureCollectionView()

        activityIndicator.startAnimating()
    }

    // ------------------------------------------------
    // MARK: - Buton Action's
    // ------------------------------------------------

    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        activityIndicator.startAnimating()
        viewModel?.start()
    }

    // ------------------------------------------------
    // MARK: - Private methods
    // ------------------------------------------------

    private func configureView() {
        setupNavigationBar(title: viewModel?.title, color: .dsWhite)
        tryAgainButton.isHidden = true
        tryAgainButton.dsConfigure(text: NSLocalizedString("Try Again", comment: ""), style: .secondary, state: .enabled)
        activityIndicator.color = .dsSecondaryPure
    }

    private func updateDataSource() {
        self.activityIndicator.stopAnimating()
        charactersCollectionView.reloadData()
    }

    /// Setup the charecterCollectionView flow layout.
    private func configureCollectionView() {
        self.charactersCollectionView.register(UINib(nibName: CharacterCell.kCellId, bundle: Bundle(for: CharacterCell.self)), forCellWithReuseIdentifier: CharacterCell.kCellId)

        self.charactersCollectionView.dataSource = self
        self.charactersCollectionView.delegate = self

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let spacing: CGFloat = 12.0
        let widthCell = (UIScreen.main.bounds.width - spacing * 4)/3
        flowLayout.itemSize = CGSize(width: widthCell, height: widthCell + 20)
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: spacing, bottom: 0, right: spacing)
        self.charactersCollectionView.collectionViewLayout = flowLayout
    }

 }

// --------------------------------------------------------------
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
// --------------------------------------------------------------

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.numberOfItemsInSection(section: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()

        if let characterCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.kCellId, for: indexPath) as? CharacterCell {

            let urlImge = self.viewModel?.characterUrlImgeAtIndex(index: indexPath.row) ?? ""
            let characterName = self.viewModel?.characterNameAtIndex(index: indexPath.row) ?? ""

            characterCell.fill(characterName: characterName, urlImge: urlImge)

            cell = characterCell
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /// Pagination
        if indexPath.row == viewModel?.numLastCharacterToShow && viewModel?.loadMore ?? false {
            self.activityIndicator.startAnimating()
            viewModel?.paginate()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.cellAtIndexTapped(index: indexPath.row)
     }

}

// --------------------------------------------------------------
// MARK: - HomeViewModelViewDelegate
// --------------------------------------------------------------
extension HomeViewController: HomeViewModelViewDelegate {
    func showError() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tryAgainButton.isHidden = false

            /// Modal message
            let dialogModal = DialogViewController(image: DSImage(named: .icon_info) ?? UIImage(), title: self.viewModel?.errorMessaje?.0 ?? "", subtitle: self.viewModel?.errorMessaje?.1 ?? "", titlePrimaryButton: NSLocalizedString("Accept", comment: ""), hideCloseButton: false, delegate: self)
            self.showDialogModal(dialogViewController: dialogModal)
        }
    }

    /// General notification when the view should be update.
    ///
    /// In this case we do not use it, we use loadCharacters since it is the only element in the whole view is the list of characters.
    func updateScreen() {
    }

    /// Notifies that the characterDataSource has changed and the view needs to be updated.
    func loadCharacters() {
        DispatchQueue.main.async {
            self.tryAgainButton.isHidden = true
            self.updateDataSource()
        }
    }
}

// --------------------------------------------------------------
// MARK: - DialogButtonViewDelegate
// --------------------------------------------------------------
extension HomeViewController: DialogViewControllerDelegate {

    func tapPrincipalButton() {
    }

    func tapSecondaryButton() {
    }

    func tapCloseButton() {
    }

}
