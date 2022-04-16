//
//  CharacterDetailViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import UIKit

final class CharacterDetailViewController: BaseViewController {
    
    //------------------------------------------------
    // MARK: - Outlets
    //------------------------------------------------
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var comicsSeriesCollectionView: UICollectionView!
    @IBOutlet weak var comicActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var serieActivityIndicator: UIActivityIndicatorView!
    
    //------------------------------------------------
    // MARK: - Variables and constants
    //------------------------------------------------
    
    /// Set the model of the view.
    internal var viewModel: CharacterDetailViewModel? {
        return self.baseViewModel as? CharacterDetailViewModel
    }

    //------------------------------------------------
    // MARK: - LifeCycle
    //------------------------------------------------
    
    /// IMPORTANT: setup will always run first
    /// viewDidLoad
    /// viewWillAppear
    /// viewDidAppear
    /// viewDidDisappear

    deinit {
        print("CharacterDetailViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Setup the view.
    override internal func setup() {
        viewModel?.setView(self)
        configureView()
        configureCollectionView()
        
        comicActivityIndicator.startAnimating()
        serieActivityIndicator.startAnimating()
        print("___ setup CharacterDetailViewController")
    }
    
    /// Actions to take when the back button is pressed and the screen is going to be deleted.
    ///
    /// In this case we do not need to take any action.
    override func backButtonPressed() {
    }

    //------------------------------------------------
    // MARK: - Private methods
    //------------------------------------------------
    
    private func configureView() {
        self.setupNavigationBar(title: viewModel?.title)
        comicActivityIndicator.color = .secondaryColor
        serieActivityIndicator.color = .secondaryColor
        
        characterDescriptionLabel.configure(with: viewModel?.character?.description, font: .boldSmall, color: .whiteColor)
            
        characterImageView.layer.cornerRadius = 75
        let urlImge = "\(viewModel?.character?.thumbnail?.path ?? "").\(viewModel?.character?.thumbnail?.typeExtension ?? "")"
        characterImageView.kf.setImage(with: URL(string: urlImge), placeholder: UIImage(named: "marverComics"))
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
        
        let compositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let inset: CGFloat = 14.0
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(150 + 80))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: inset, trailing: 0)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(150 + 80))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)
            
            // Supplementary Item
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [headerItem]
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        })
        self.comicsSeriesCollectionView.collectionViewLayout = compositionalLayout

    }

}

//--------------------------------------------------------------
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//--------------------------------------------------------------

extension CharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.viewModel?.comics.count ?? 0
        case 1:
            return self.viewModel?.series.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        switch indexPath.section {
        case 0:
            if let comicSerieCell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicSerieCell.kCellId, for: indexPath) as? ComicSerieCell {
                
                if let comic = self.viewModel?.comics[indexPath.row] {
                    comicSerieCell.fill(title: comic.title ?? "", year: comic.year ?? "", thumbnail: comic.thumbnail)
                    cell = comicSerieCell
                }
            }
        case 1:
            if let comicSerieCell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicSerieCell.kCellId, for: indexPath) as? ComicSerieCell {
                
                if let serie = self.viewModel?.series[indexPath.row] {
                    comicSerieCell.fill(title: serie.title ?? "", year: serie.startYear.map(String.init) ?? "", thumbnail: serie.thumbnail)
                    cell = comicSerieCell
                }
            }
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            /// Comic Pagination
            if indexPath.row == viewModel?.numLastComicToShow && (viewModel?.loadMoreComic ?? false) {
                self.comicActivityIndicator.startAnimating()
                viewModel?.paginateComic()
            }
        case 1:
            /// Serie Pagination
            if indexPath.row == viewModel?.numLastSerieToShow  && (viewModel?.loadMoreSerie ?? false) {
                self.serieActivityIndicator.startAnimating()
                viewModel?.paginateSerie()
            }
        default:
            break
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSupplementaryView.kCellId, for: indexPath) as? HeaderSupplementaryView else {
            return HeaderSupplementaryView()
        }

        indexPath.section == 0 ? headerView.headerTitleLabel.configure(with: NSLocalizedString("Comics", comment: ""), font: .semiboldLarge, color: .whiteColor) : headerView.headerTitleLabel.configure(with: NSLocalizedString("Series", comment: ""), font: .semiboldLarge, color: .whiteColor)
        
        return headerView
    }
    
}

//--------------------------------------------------------------
// MARK: - CharacterDetailViewModelViewDelegate
//--------------------------------------------------------------

extension CharacterDetailViewController: CharacterDetailViewModelViewDelegate {
    
    /// General notification when the view should be load.
    ///
    /// in this case we do not use it, we use loadComics and loadSeries since they are the only element in the whole view is the list of characters.
    func updateScreen() {
        print("updateScreen CharacterDetail!!!")
    }
    
    /// Notifies that the comisDataSource has changed and the view needs to be updated.
    func loadComics() {
        self.updateDataSourceComic()
    }
    
    /// Notifies that the seriesDataSource has changed and the view needs to be updated.
    func loadSeries() {
        self.updateDataSourceSerie()
    }
    
    func showError() {
        comicActivityIndicator.stopAnimating()
        serieActivityIndicator.stopAnimating()
        self.showSimpleAlertAccept(alertTitle: viewModel?.errorMessaje ?? "", alertMessage: "")
    }
}
