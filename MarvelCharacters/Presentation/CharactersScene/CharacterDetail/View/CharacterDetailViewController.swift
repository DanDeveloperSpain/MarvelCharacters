//
//  CharacterDetailViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa
import RxDataSources
import DanDesignSystem

final class CharacterDetailViewController: UIViewController, CustomizableNavBar, Modable {

    // ------------------------------------------------
    // MARK: - Outlets
    // ------------------------------------------------

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var filterByYearLabel: UILabel!
    @IBOutlet weak var yearFilterTextField: UITextField!
    @IBOutlet weak var comicsSeriesCollectionView: UICollectionView!
    @IBOutlet weak var comicActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var serieActivityIndicator: UIActivityIndicatorView!

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    private let reuseIdentifier = ComicSerieCell.kCellId
    private let disposeBag = DisposeBag()
    var viewModel: CharacterDetailViewModel!
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, ComicSerieCell.UIModel>>!

    var pickerViewFilter = UIPickerView()

    // ---------------------------------
    // MARK: - Life Cycle
    // ---------------------------------

    static func create(viewModel: CharacterDetailViewModel) -> CharacterDetailViewController {
        let view = CharacterDetailViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        configureView()
        setupCollectionViewBindings()
        setupLoadingsBindings()
        setupYearsToFilterBinding()
        setupYearFilterTextFieldBinding()
        setupErrorBinding()
        viewModel.start()
    }
    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    private func configureView() {
        setupNavigationBar(title: viewModel?.title, color: .dsWhite, configureBackButton: true)

        self.view.setBackgroundImage(imageName: "marvelBackground")

        comicActivityIndicator.color = .dsSecondaryPure
        serieActivityIndicator.color = .dsSecondaryPure

        characterDescriptionLabel.dsConfigure(with: viewModel?.character?.description, font: .boldSmall, color: .dsWhite)

        characterImageView.layer.cornerRadius = 75
        characterImageView.sd_setImage(with: URL(string: viewModel?.character?.imageUrl ?? ""), placeholderImage: DSImage(named: .marverComics))

        setupPickerViewFilter()
        setupCollectionView()
    }

    // ------------------------------------------------
    // MARK: - Buton Action's
    // ------------------------------------------------

    @objc func donePressed() {
        yearFilterTextField.resignFirstResponder()
    }
}

// --------------------------------------------------------------
// MARK: - Bindings
// --------------------------------------------------------------
extension CharacterDetailViewController {

    private func setupCollectionViewBindings() {

        dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, ComicSerieCell.UIModel>>(
            configureCell: { _, collectionView, indexPath, item -> ComicSerieCell in
                var cell = ComicSerieCell()
                if let comicSerieCell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicSerieCell.kCellId, for: indexPath) as? ComicSerieCell {
                    comicSerieCell.fill(title: item.title ?? "", year: item.year ?? "", urlImge: item.imageURL ?? "")
                    cell = comicSerieCell
                }
                return cell
            }
        )

        dataSource.configureSupplementaryView = { (_, collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSupplementaryView.kCellId, for: indexPath) as? HeaderSupplementaryView else {
                return HeaderSupplementaryView()
            }
            headerView.setup(section: indexPath.section)
            return headerView
        }

        viewModel.items
            .asObservable()
            .bind(to: comicsSeriesCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        comicsSeriesCollectionView
            .rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] _, indexPath in
                if indexPath.section == 0 {
                    self?.viewModel.checkComicsRequestNewDataByIndex(index: indexPath.row)
                } else if indexPath.section == 1 {
                    self?.viewModel.checkSeriesRequestNewDataByIndex(index: indexPath.row)
                }
            }).disposed(by: disposeBag)
    }

    private func setupLoadingsBindings() {
        viewModel.isComicsLoading
            .asDriver()
            .drive(comicActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.isSeriesLoading
            .asDriver()
            .drive(serieActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }

    private func setupYearsToFilterBinding() {
        viewModel.yearsToFilter.bind(to: pickerViewFilter.rx.itemTitles) { (row, yearToFilter) in
            return row == 0 ? NSLocalizedString("all", comment: "") : String(yearToFilter)
        }
        .disposed(by: disposeBag)

        pickerViewFilter.rx.modelSelected(Int.self)
            .subscribe(onNext: { [weak self] models in
                self?.yearFilterTextField.text = models[0] == 0 ? NSLocalizedString("all", comment: "") : String(models[0])
                self?.viewModel.setFilterYearToItems(yearToFilter: models[0])
            })
            .disposed(by: disposeBag)
    }

    private func setupYearFilterTextFieldBinding() {
        viewModel.yearFilterTextFieldIsHidden
            .asDriver()
            .drive(yearFilterTextField.rx.isHidden)
            .disposed(by: disposeBag)
    }

    private func setupErrorBinding() {
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showError(errorToShow: error)
            }).disposed(by: disposeBag)
    }

}

// --------------------------------------------------------------
// MARK: - CollectionView Layout
// --------------------------------------------------------------
extension CharacterDetailViewController {
    /// Setup the collectionView for comics ands series flow layout.
    private func setupCollectionView() {
        self.comicsSeriesCollectionView.register(UINib(nibName: ComicSerieCell.kCellId, bundle: Bundle(for: ComicSerieCell.self)), forCellWithReuseIdentifier: ComicSerieCell.kCellId)
        self.comicsSeriesCollectionView.register(UINib(nibName: HeaderSupplementaryView.kCellId, bundle: Bundle(for: HeaderSupplementaryView.self)), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.kCellId)

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

// ------------------------------------------------
// MARK: - PickerViewFilter
// ------------------------------------------------
extension CharacterDetailViewController {

    private func setupPickerViewFilter() {
        filterByYearLabel.dsConfigure(with: NSLocalizedString("filter_by_year", comment: ""), font: .boldMedium, color: .dsWhite)

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)

        yearFilterTextField.inputView = pickerViewFilter
        yearFilterTextField.inputAccessoryView = toolbar
        yearFilterTextField.text = NSLocalizedString("all", comment: "")
    }
}

// ------------------------------------------------
// MARK: - ShowError
// ------------------------------------------------
extension CharacterDetailViewController {

    private func showError(errorToShow: String) {
        self.showDialogModal(image: DSImage(named: .icon_info) ?? UIImage(), title: errorToShow, titlePrimaryButton: NSLocalizedString("Accept", comment: ""), delegate: self)
    }
}

// ------------------------------------------------
// MARK: - Handle Keyboard
// ------------------------------------------------
extension CharacterDetailViewController {

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
                self.view.frame.origin.y -= keyboardSize.height - (tabBarHeight ?? 0)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
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
