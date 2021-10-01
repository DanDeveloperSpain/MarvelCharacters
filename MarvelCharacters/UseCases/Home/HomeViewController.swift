//
//  HomeViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 29/9/21.
//

import UIKit

final class HomeViewController: UIViewController {
    
    //------------------------------------------------
    // MARK: - Outlets
    //------------------------------------------------
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    //------------------------------------------------
    // MARK: - Variables and constants
    //------------------------------------------------

    let characterService = CharacterService()
    private(set) var homeViewModel: HomeViewModel?
    let util = Util()
 
    //------------------------------------------------
    // MARK: - LifeCycle
    //------------------------------------------------

     override func viewDidLoad() {
         super.viewDidLoad()
        
        configureView()
        configureCollectionView()
        
        activityIndicator.startAnimating()
        
        homeViewModel = HomeViewModel(characterService: characterService)
        
        homeViewModel?.bindCharactersViewModelToController = {
            self.charactersCollectionView.isHidden = false
            self.tryAgainButton.isHidden = true
            self.updateDataSource()
        }
         
        homeViewModel?.binderrorMessajeViewModelToController = {
            self.showError()
        }

    }
    
    //------------------------------------------------
    // MARK: - Button actions
    //------------------------------------------------

    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        activityIndicator.startAnimating()
        homeViewModel?.getCharacters()
    }

    //------------------------------------------------
    // MARK: - Private methods
    //------------------------------------------------
    private func configureView(){
        tryAgainButton.isHidden = true
        activityIndicator.color = .PRINCIPAL_COLOR
    }
    
    private func updateDataSource(){
        self.activityIndicator.stopAnimating()
        charactersCollectionView.reloadData()
        
    }
    
    private func configureCollectionView(){
        self.charactersCollectionView.register(UINib(nibName: CharacterCell.kCellId, bundle: Bundle(for: CharacterCell.self)), forCellWithReuseIdentifier: CharacterCell.kCellId)
        
        self.charactersCollectionView.dataSource = self
        self.charactersCollectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let spacing : CGFloat = 12.0
        let widthCell = (UIScreen.main.bounds.width - spacing * 4)/3
        flowLayout.itemSize = CGSize(width: widthCell , height: widthCell)
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        self.charactersCollectionView.collectionViewLayout = flowLayout
    }
    
    private func showError(){
        activityIndicator.stopAnimating()
        charactersCollectionView.isHidden = true
        tryAgainButton.isHidden = false
        util.showSimpleAlertAccept(viewController: self, alertTitle: NSLocalizedString(self.homeViewModel?.errorMessaje ?? "", comment: ""), alertMessage: "")
    }
 
 }

//--------------------------------------------------------------
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//--------------------------------------------------------------

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeViewModel?.characters.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let characterCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.kCellId, for: indexPath) as? CharacterCell {
            
            if let character = self.homeViewModel?.characters[indexPath.row] {
                characterCell.fill(character: character)
                cell = characterCell
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Pagination
        if indexPath.row == (homeViewModel?.responseCharactersData?.offset ?? 0) + (homeViewModel?.responseCharactersData?.count ?? 0) - 1 {
            self.activityIndicator.startAnimating()
            homeViewModel?.paginate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let characterSelected = homeViewModel?.characters[indexPath.row] {
            let characterDetailViewModel = CharacterDetailViewModel(character: characterSelected, characterService: characterService)
            let characterDetailVC = CharacterDetailViewController()
            characterDetailVC.characterDetailViewModel = characterDetailViewModel
            self.present(characterDetailVC, animated: true, completion: nil)
        }
     }

    
}
