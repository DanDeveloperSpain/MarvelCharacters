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

final class CharactersListViewController: UIViewController, CustomizableNavBar, Modable {

    // ------------------------------------------------
    // MARK: - Outlets
    // ------------------------------------------------

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var tryAgainButton: UIButton!

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private var viewModel: CharactersListViewModel!

    private let reuseIdentifier = CharacterCell.kCellId
    private let disposeBag = DisposeBag()

    // ---------------------------------
    // MARK: - Life Cycle
    // ---------------------------------

    static func create(viewModel: CharactersListViewModel) -> CharactersListViewController {
        let view = CharactersListViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCollectionView()
        setupBindings()
        setupCocoaBindings()
        viewModel.start()
    }

    // ---------------------------------
    // MARK: - Bindings
    // ---------------------------------

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

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    private func configureView() {
        setupNavigationBar(title: viewModel?.title, color: .dsWhite)

        self.view.setBackgroundImage(imageName: "marvelBackground")

        tryAgainButton.isHidden = true
        tryAgainButton.dsConfigure(text: NSLocalizedString("Try Again", comment: ""), style: .secondary, state: .enabled)

        activityIndicator.color = .dsSecondaryPure
    }

    // ------------------------------------------------
    // MARK: - Buton Action's
    // ------------------------------------------------

    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        viewModel.start()
    }

    // ------------------------------------------------
    // MARK: - Private methods
    // ------------------------------------------------

    /// Setup the charecterCollectionView flow layout.
    private func configureCollectionView() {
        self.charactersCollectionView.register(UINib(nibName: CharacterCell.kCellId, bundle: Bundle(for: CharacterCell.self)), forCellWithReuseIdentifier: CharacterCell.kCellId)

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
        self.showDialogModal(image: DSImage(named: .icon_info) ?? UIImage(), title: errorToShow, titlePrimaryButton: NSLocalizedString("Accept", comment: ""), delegate: self)
    }

 }

// --------------------------------------------------------------
// MARK: - DialogButtonViewDelegate
// --------------------------------------------------------------
extension CharactersListViewController: DialogViewControllerDelegate {

    func tapPrincipalButton() {
    }

    func tapSecondaryButton() {
    }

    func tapCloseButton() {
    }

}
