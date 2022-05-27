//
//  CharacterDetailViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import UIKit
import SDWebImage
import DanDesignSystem

final class CharacterDetailViewController: BaseViewController {

    // ------------------------------------------------
    // MARK: - Outlets
    // ------------------------------------------------

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var comicsSeriesCollectionView: UICollectionView!
    @IBOutlet weak var comicActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var serieActivityIndicator: UIActivityIndicatorView!

    // ------------------------------------------------
    // MARK: - Properties
    // ------------------------------------------------

    /// Set the model of the view.
    internal var viewModel: CharacterDetailViewModel? {
        return self.baseViewModel as? CharacterDetailViewModel
    }

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    /// Setup the view.
    override internal func setup() {
        viewModel?.setView(self)
        configureView()
        configureCollectionView()

        comicActivityIndicator.startAnimating()
        serieActivityIndicator.startAnimating()
    }

    /// Actions to take when the back button is pressed and the screen is going to be deleted.
    ///
    /// In this case we do not need to take any action.
    override func backButtonPressed() {
    }

    // ------------------------------------------------
    // MARK: - Private methods
    // ------------------------------------------------

    private func configureView() {
        setupNavigationBar(title: viewModel?.title, color: .dsWhite, configureBackButton: true)
        comicActivityIndicator.color = .dsSecondaryPure
        serieActivityIndicator.color = .dsSecondaryPure

        characterDescriptionLabel.dsConfigure(with: viewModel?.character?.description, font: .boldSmall, color: .dsWhite)

        characterImageView.layer.cornerRadius = 75
        let urlImge = "\(viewModel?.character?.thumbnail?.path ?? "").\(viewModel?.character?.thumbnail?.typeExtension ?? "")"
        characterImageView.sd_setImage(with: URL(string: urlImge), placeholderImage: DSImage(named: .marverComics))
    }

    private func updateDataSourceComic() {
        comicActivityIndicator.stopAnimating()
        comicsSeriesCollectionView.reloadData()
    }

    private func updateDataSourceSerie() {
        serieActivityIndicator.stopAnimating()
        comicsSeriesCollectionView.reloadData()
    }

    /// Setup the collectionView for comics ands series flow layout.
    private func configureCollectionView() {
        self.comicsSeriesCollectionView.register(UINib(nibName: ComicSerieCell.kCellId, bundle: Bundle(for: ComicSerieCell.self)), forCellWithReuseIdentifier: ComicSerieCell.kCellId)
        self.comicsSeriesCollectionView.register(UINib(nibName: HeaderSupplementaryView.kCellId, bundle: Bundle(for: HeaderSupplementaryView.self)), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.kCellId)

        self.comicsSeriesCollectionView.dataSource = self
        self.comicsSeriesCollectionView.delegate = self

        let compositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
            let widthCell: CGFloat = 150.0
            let heightCell: CGFloat = 240.0
            let heightHeaderCell: CGFloat = 40.0
            let inset: CGFloat = 14.0

            /// layout for Item and Group
            let layoutSize = NSCollectionLayoutSize(widthDimension: .absolute(widthCell), heightDimension: .absolute(heightCell))

            // Item
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: inset, trailing: 0)

            // Group
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])

            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)

            // Supplementary Item
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(heightHeaderCell))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [headerItem]
            section.orthogonalScrollingBehavior = .continuous

            return section
        })
        self.comicsSeriesCollectionView.collectionViewLayout = compositionalLayout

    }

}

// --------------------------------------------------------------
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
// --------------------------------------------------------------

extension CharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSectionsInCollectionView() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInSection(section: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()

        let mediaType: MediaType = indexPath.section == 0 ? .comic : .serie

        if let comicSerieCell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicSerieCell.kCellId, for: indexPath) as? ComicSerieCell {

            let urlImge = self.viewModel?.urlImgeAtIndex(index: indexPath.row, type: mediaType) ?? ""
            let comicTitle = self.viewModel?.titleAtIndex(index: indexPath.row, type: mediaType) ?? ""
            let comicYear = self.viewModel?.yearAtIndex(index: indexPath.row, type: mediaType) ?? ""

            comicSerieCell.fill(title: comicTitle, year: comicYear, urlImge: urlImge)

            cell = comicSerieCell
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            /// Comic Pagination
            if indexPath.row == viewModel?.numLastComicToShow && (viewModel?.loadMoreComic ?? false) {
                self.comicActivityIndicator.startAnimating()
                viewModel?.paginate(mediaType: .comic)
            }
        case 1:
            /// Serie Pagination
            if indexPath.row == viewModel?.numLastSerieToShow  && (viewModel?.loadMoreSerie ?? false) {
                self.serieActivityIndicator.startAnimating()
                viewModel?.paginate(mediaType: .serie)
            }
        default:
            break
        }

    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSupplementaryView.kCellId, for: indexPath) as? HeaderSupplementaryView else {
            return HeaderSupplementaryView()
        }

        indexPath.section == 0 ? headerView.headerTitleLabel.dsConfigure(with: NSLocalizedString("Comics", comment: ""), font: .boldLarge, color: .dsWhite) : headerView.headerTitleLabel.dsConfigure(with: NSLocalizedString("Series", comment: ""), font: .boldLarge, color: .dsWhite)

        return headerView
    }

}

// --------------------------------------------------------------
// MARK: - CharacterDetailViewModelViewDelegate
// --------------------------------------------------------------

extension CharacterDetailViewController: CharacterDetailViewModelViewDelegate {

    /// General notification when the view should be update.
    ///
    /// in this case we do not use it, we use loadComics and loadSeries since they are the only element in the whole view is the list of characters.
    func updateScreen() {
    }

    /// Notifies that the comisDataSource has changed and the view needs to be updated.
    func loadComics() {
        DispatchQueue.main.async {
            self.updateDataSourceComic()
        }
    }

    /// Notifies that the seriesDataSource has changed and the view needs to be updated.
    func loadSeries() {
        DispatchQueue.main.async {
            self.updateDataSourceSerie()
        }
    }

    func showError() {
        DispatchQueue.main.async {
            self.comicActivityIndicator.stopAnimating()
            self.serieActivityIndicator.stopAnimating()

            /// Modal message
            let dialogModal = DialogViewController(image: DSImage(named: .icon_info) ?? UIImage(), title: self.viewModel?.errorMessaje ?? "", titlePrimaryButton: NSLocalizedString("Accept", comment: ""), hideCloseButton: false, delegate: self)
            self.showDialogModal(dialogViewController: dialogModal)
        }
    }
}

// --------------------------------------------------------------
// MARK: - DialogButtonViewDelegate
// --------------------------------------------------------------
extension CharacterDetailViewController: DialogViewControllerDelegate {

    func tapPrincipalButton() {
    }

    func tapSecondaryButton() {
    }

    func tapCloseButton() {
    }

}
