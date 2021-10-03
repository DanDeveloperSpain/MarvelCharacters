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
    
    var homeViewModel: HomeViewModel?
 
    //------------------------------------------------
    // MARK: - LifeCycle
    //------------------------------------------------

     override func viewDidLoad() {
         super.viewDidLoad()
        
         configureView()
         configureCollectionView()
        
         activityIndicator.startAnimating()
        
         homeViewModel?.bindingCharacter = {
             self.tryAgainButton.isHidden = true
             self.updateDataSource()
         }
         
         homeViewModel?.bindingError = {
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
    private func configureView() {
        self.title = NSLocalizedString("Marvel characters", comment: "")
        tryAgainButton.isHidden = true
        activityIndicator.color = .PRINCIPAL_COLOR
    }
    
    private func updateDataSource() {
        self.activityIndicator.stopAnimating()
        charactersCollectionView.reloadData()
        
    }
    
    private func configureCollectionView() {
        self.charactersCollectionView.register(UINib(nibName: CharacterCell.kCellId, bundle: Bundle(for: CharacterCell.self)), forCellWithReuseIdentifier: CharacterCell.kCellId)
        
        self.charactersCollectionView.dataSource = self
        self.charactersCollectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let spacing : CGFloat = 12.0
        let widthCell = (UIScreen.main.bounds.width - spacing * 4)/3
        flowLayout.itemSize = CGSize(width: widthCell , height: widthCell + 20)
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: spacing, bottom: 0, right: spacing)
        self.charactersCollectionView.collectionViewLayout = flowLayout
    }
    
    private func showError() {
        activityIndicator.stopAnimating()
        tryAgainButton.isHidden = false
        homeViewModel?.showSimpleAlert()
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
        if indexPath.row == (homeViewModel?.charactersDataResponse?.offset ?? 0) + (homeViewModel?.charactersDataResponse?.count ?? 0) - 1 && (homeViewModel?.loadMore ?? true) {
            self.activityIndicator.startAnimating()
            homeViewModel?.paginate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let characterSelected = homeViewModel?.characters[indexPath.row] {
            self.homeViewModel?.showCharacterDetail(character: characterSelected)
        }
     }
    
}
