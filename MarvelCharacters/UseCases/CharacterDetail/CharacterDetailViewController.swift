//
//  CharacterDetailViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    //------------------------------------------------
    // MARK: - Outlets
    //------------------------------------------------
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var comicsSeriesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //------------------------------------------------
    // MARK: - Variables and constants
    //------------------------------------------------
    
    let characterService = CharacterService()
    var characterDetailViewModel: CharacterDetailViewModel?
    let util = Util()

    //------------------------------------------------
    // MARK: - LifeCycle
    //------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionView()
        
        activityIndicator.startAnimating()
        
        characterDetailViewModel?.bindCharacterDetailViewModelToController = {
            self.activityIndicator.startAnimating()
            self.updateDataSource()
        }
        
    }

    //------------------------------------------------
    // MARK: - Private methods
    //------------------------------------------------
    
    private func configureView(){
        activityIndicator.color = .PRINCIPAL_COLOR
        
        characterNameLabel.text = characterDetailViewModel?.character?.name
        characterDescriptionLabel.text = characterDetailViewModel?.character?.description
            
        characterImageView.layer.cornerRadius = 75
        let urlImge = "\(characterDetailViewModel?.character?.thumbnail.path ?? "").\(characterDetailViewModel?.character?.thumbnail.typeExtension ?? "")"
        characterImageView.kf.setImage(with: URL(string: urlImge), placeholder: UIImage(named: "logo-thumbnail"))
    }
    
    private func updateDataSource(){
        self.activityIndicator.stopAnimating()
        comicsSeriesCollectionView.reloadData()
        
    }
    
    private func configureCollectionView(){
        self.comicsSeriesCollectionView.register(UINib(nibName: ComicSerieCell.kCellId, bundle: Bundle(for: ComicSerieCell.self)), forCellWithReuseIdentifier: ComicSerieCell.kCellId)
        
        self.comicsSeriesCollectionView.dataSource = self
        self.comicsSeriesCollectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let spacing : CGFloat = 14.0
        let widthCell = 150
        flowLayout.itemSize = CGSize(width: widthCell, height: widthCell + 80)
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        self.comicsSeriesCollectionView.collectionViewLayout = flowLayout
    }

}

//--------------------------------------------------------------
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//--------------------------------------------------------------

extension CharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.characterDetailViewModel?.comics.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let comicSerieCell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicSerieCell.kCellId, for: indexPath) as? ComicSerieCell {
            
            if let comic = self.characterDetailViewModel?.comics[indexPath.row] {
                comicSerieCell.fill(comic: comic)
                cell = comicSerieCell
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Pagination
        if indexPath.row == (characterDetailViewModel?.responseComicsData?.offset ?? 0) + (characterDetailViewModel?.responseComicsData?.count ?? 0) - 1 {
            self.activityIndicator.startAnimating()
            characterDetailViewModel?.paginate()
        }
    }
    
}
