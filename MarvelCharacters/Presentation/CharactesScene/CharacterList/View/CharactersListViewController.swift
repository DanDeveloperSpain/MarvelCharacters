//
//  CharactersListViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 29/9/21.
//

import UIKit
import RxSwift
import RxCocoa
import DanDesignSystem

final class CharactersListViewController: UIViewController { // BaseViewController {

    // ------------------------------------------------
    // MARK: - Outlets
    // ------------------------------------------------

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var tryAgainButton: UIButton!

    private let reuseIdentifier = CharacterCell.kCellId
    private let disposeBag = DisposeBag()
    var viewModel: CharactersListViewModel!
    // var coordinator: MainCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCollectionView()
        setupBindings()
        setupCocoaBindings()
        viewModel.fetchCharactersLaunchesList()
    }

    private func setupBindings() {
        viewModel.isLoading
            .asDriver()
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.cellUIModels
            .observe(on: MainScheduler.instance)
            .bind(to: charactersCollectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: CharacterCell.self)) { _, uiModel, cell in
                cell.uiModel = uiModel
            }
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showError(errorToShow: error)
            }).disposed(by: disposeBag)

        viewModel.tryAgainButtonisHidden
            .asDriver()
            .drive(tryAgainButton.rx.isHidden)
            .disposed(by: disposeBag)
    }

    private func setupCocoaBindings() {
        charactersCollectionView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.cellAtIndexTapped(index: indexPath.row)
            }).disposed(by: disposeBag)

        charactersCollectionView
            .rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] _, indexPath in
                self?.viewModel.checkRequestNewDataByIndex(index: indexPath.row)
            }).disposed(by: disposeBag)
    }

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    /// Set the model of the view.
//    private var viewModel: CharactersListViewModel? {
//        return self.baseViewModel as? CharactersListViewModel
//    }

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    /// Setup the view.
//    override internal func setup() {
//        viewModel?.setView(self)
//        configureView()
//        configureCollectionView()
//
//        activityIndicator.startAnimating()
//    }

    // ------------------------------------------------
    // MARK: - Buton Action's
    // ------------------------------------------------

    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        viewModel.fetchCharactersLaunchesList()
    }

    // ------------------------------------------------
    // MARK: - Private methods
    // ------------------------------------------------

    private func configureView() {
        // setupNavigationBar(title: viewModel?.title, color: .dsWhite)
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

//        self.charactersCollectionView.dataSource = self
//        self.charactersCollectionView.delegate = self

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let spacing: CGFloat = 12.0
        let widthCell = (UIScreen.main.bounds.width - spacing * 4)/3
        flowLayout.itemSize = CGSize(width: widthCell, height: widthCell + 20)
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: spacing, bottom: 0, right: spacing)
        self.charactersCollectionView.collectionViewLayout = flowLayout
    }

    private func showError(errorToShow: String) {
        let dialogModal = DialogViewController(image: DSImage(named: .icon_info) ?? UIImage(), title: errorToShow, titlePrimaryButton: NSLocalizedString("Accept", comment: ""), delegate: self)
        self.showDialogModal(dialogViewController: dialogModal)
    }

    // QUITAR DE AQUI
    func showDialogModal(dialogViewController: DialogViewController) {
        self.present(dialogViewController, animated: true, completion: nil)
    }

 }

// --------------------------------------------------------------
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
// --------------------------------------------------------------

// extension CharactersListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.viewModel?.numberOfItemsInSection(section: section) ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        var cell = UICollectionViewCell()
//
//        if let characterCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.kCellId, for: indexPath) as? CharacterCell {
//
//            let urlImge = self.viewModel?.characterUrlImgeAtIndex(index: indexPath.row) ?? ""
//            let characterName = self.viewModel?.characterNameAtIndex(index: indexPath.row) ?? ""
//
//            characterCell.fill(characterName: characterName, urlImge: urlImge)
//
//            cell = characterCell
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        /// Pagination
//        if indexPath.row == viewModel?.numLastCharacterToShow && viewModel?.loadMore ?? false {
//            self.activityIndicator.startAnimating()
//            viewModel?.paginate()
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.viewModel?.cellAtIndexTapped(index: indexPath.row)
//     }
//
// }

// --------------------------------------------------------------
// MARK: - CharactersListViewModelViewDelegate
// --------------------------------------------------------------
extension CharactersListViewController: CharactersListViewModelViewDelegate {
    func showError() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tryAgainButton.isHidden = false

            /// Modal message
            // let dialogModal = DialogViewController(image: DSImage(named: .icon_info) ?? UIImage(), title: self.viewModel?.errorMessaje?.0 ?? "", subtitle: self.viewModel?.errorMessaje?.1 ?? "", titlePrimaryButton: NSLocalizedString("Accept", comment: ""), hideCloseButton: false, delegate: self)
            // self.showDialogModal(dialogViewController: dialogModal)
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
extension CharactersListViewController: DialogViewControllerDelegate {

    func tapPrincipalButton() {
        tryAgainButton.isHidden = false
    }

    func tapSecondaryButton() {
    }

    func tapCloseButton() {
    }

}
