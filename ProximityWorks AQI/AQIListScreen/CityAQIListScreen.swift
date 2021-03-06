//
//  ViewController.swift
//  ProximityWorks AQI
//
//  Created by Gaurav Yadav on 21/12/21.
//

import UIKit

class CityAQIListViewController: UIViewController, UICollectionViewDelegate, CityAQIListViewModelDelegate {
    
    @IBOutlet weak var aqiCollectionView: UICollectionView!
    
    var aqiDatasource: UICollectionViewDiffableDataSource<AQIListSection, AQIUpdate>!
    
    var viewModel: CityAQIListViewModel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        //ViewController scaffholding would be doe by a central router
        let router = Router()
        router.source = self
        viewModel = ViewModel(router: router)
        viewModel.viewDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aqiCollectionView.delegate = self
        configureLayout()
        configureDatasource()
        registerCells()
        viewModel.onLoad()
    }
    
    func configureDatasource() {
        aqiDatasource = UICollectionViewDiffableDataSource(collectionView: aqiCollectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityAQIListCell.reuseIdentifier, for: indexPath) as? CityAQIListCell else { return nil }
            cell.setup(item)
            return cell
        }
    }
    
    func configureLayout() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.showsSeparators = false
        aqiCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func registerCells() {
        aqiCollectionView.register(.aqiListCell, forCellWithReuseIdentifier: CityAQIListCell.reuseIdentifier)
    }
    
    func updateSnapshot(with aqis: [AQIUpdate]) {
        var snapshot = aqiDatasource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(aqis, toSection: .main)
        aqiDatasource.apply(snapshot)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.onSelect(aqiDatasource.snapshot().itemIdentifiers[indexPath.item])
    }

}
