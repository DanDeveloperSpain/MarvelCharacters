//
//  CharacterDetailViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import UIKit

protocol CharacterDetailViewControllerProtocol: BaseControllerViewModelProtocol {
    func loadComics() -> Void
    func loadSeries() -> Void
    func loadError() -> Void
}

class CharacterDetailViewController: BaseViewController {
    
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
    
    private var viewModel: CharacterDetailViewModel? {
        return self._viewModel as? CharacterDetailViewModel
    }

    //------------------------------------------------
    // MARK: - LifeCycle
    //------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //------------------------------------------------
    // MARK: - Setup view
    //------------------------------------------------
    override internal func setup() {
        configureView()
        configureCollectionView()
        
        comicActivityIndicator.startAnimating()
        serieActivityIndicator.startAnimating()
    }
    
    override func backButtonPressed() {
        print("______ TEST 2")
    }

    //------------------------------------------------
    // MARK: - Private methods
    //------------------------------------------------
    
    private func configureView() {
        self.setupNavigationBar(title: viewModel?.character?.name)
        comicActivityIndicator.color = .PRINCIPAL_COLOR
        serieActivityIndicator.color = .PRINCIPAL_COLOR
        
        characterDescriptionLabel.text = viewModel?.character?.description
            
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
    
    private func showError() {
        comicActivityIndicator.stopAnimating()
        serieActivityIndicator.stopAnimating()
        viewModel?.showSimpleAlert(alertTitle: viewModel?.errorMessaje ?? "", alertMessage: "")
    }
    
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
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .absolute(self.comicsSeriesCollectionView.frame.width), heightDimension: .estimated(40))
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
            // Comic Pagination
            if indexPath.row == (viewModel?.comicsDataResponse?.offset ?? 0) + (viewModel?.comicsDataResponse?.count ?? 0) - 1 && (viewModel?.loadMoreComic ?? true) {
                self.comicActivityIndicator.startAnimating()
                viewModel?.paginateComic()
            }
        case 1:
            // Serie Pagination
            if indexPath.row == (viewModel?.seriesDataResponse?.offset ?? 0) + (viewModel?.seriesDataResponse?.count ?? 0) - 1  && (viewModel?.loadMoreSerie ?? true) {
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

        headerView.headerTitleLabel.text = indexPath.section == 0 ? NSLocalizedString("Comics", comment: "") : NSLocalizedString("Series", comment: "")
        return headerView
    }
    
}

// MARK: - CharacterDetailViewController
extension CharacterDetailViewController: CharacterDetailViewControllerProtocol {
    
    func didLoadView() {
    }
    
    func loadComics() {
        self.updateDataSourceComic()
    }
    
    func loadSeries() {
        self.updateDataSourceSerie()
    }
    
    func loadError() {
        self.showError()
    }
}
