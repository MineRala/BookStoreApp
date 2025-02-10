//
//  HomeViewController.swift
//  BookStoreApp
//
//  Created by Mine Rala on 3.02.2025.
//

import UIKit

protocol HomeViewControllerInterface: AnyObject {
    func configureNavigationBar()
    func configureCollectionView()
    func configureActivityIndicator()
    func setEmptyLabelVisibility(isVisible: Bool)
    func collectionViewReloadData()
    func collectionViewScroll(index: IndexPath)
    func isActivityIndicatorActive(isActive: Bool)
}

final class HomeViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!

    // MARK: Properties
    lazy var viewModel: HomeViewModelInterface = HomeViewModel(view: self)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
}

// MARK: - HomeViewControllerInterface
extension HomeViewController: HomeViewControllerInterface {
    func setEmptyLabelVisibility(isVisible: Bool) {
        emptyLabel.isHidden = !isVisible
        collectionView.isHidden = isVisible
    }

    func configureActivityIndicator() {
        self.activityIndicator.setActiveState(isActive: true)
        self.activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    }

    func configureNavigationBar() {
        navigationItem.backButtonTitle = Constants.emptyString
        navigationController?.navigationBar.tintColor = .gray
    }

    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.register(UINib(nibName: Constants.collectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constants.collectionViewCell)
        collectionView.collectionViewLayout = layout
    }

    func collectionViewReloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func collectionViewScroll(index: IndexPath) {
        self.collectionView.scrollToItem(at: index, at: .top, animated: true)
    }

    func isActivityIndicatorActive(isActive: Bool) {
        self.activityIndicator.setActiveState(isActive: isActive)
    }

}

// MARK: - Navigation Preparation
extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showDetailIdentifier {
            if let detailVC = segue.destination as? DetailViewController,
               let indexPath = collectionView.indexPathsForSelectedItems?.first {
                detailVC.book = viewModel.getBook(index: indexPath.row)
            }
        }
    }
}

// MARK: - Actions
extension HomeViewController {
    @IBAction func sortButtonAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: Strings.sortingOptions, message: Strings.selectOption, preferredStyle: .actionSheet)

        viewModel.optionList.forEach { actionSheet.addAction(createAction(title: $0, sortType: $1)) }

        actionSheet.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }

    private func createAction(title: String, sortType: SortType) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
            guard let self else { return }
            self.viewModel.createAction(sortType: sortType)
        }

        let isSelected = viewModel.isSortTypeSelected(sortType)
        let color: UIColor = isSelected ? .red : .black
        action.setValue(color, forKey: Constants.titleTextColor)
        return action
    }

    @IBAction func searchButtonAction(_ sender: Any) {
        performSegue(withIdentifier: Constants.searchBookIdentifier, sender: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCell, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: CollectionViewCellViewModel(book: viewModel.getBook(index: indexPath.item), view: cell))
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.calculateItemSize(for: collectionView.frame.width, spacing: 10)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: Constants.main, bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: Constants.detailViewController) as? DetailViewController {
            detailVC.book = viewModel.getBook(index: indexPath.item)
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("DetailViewController not instantiate!")
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.willDisplay(index: indexPath.item)
    }
}
