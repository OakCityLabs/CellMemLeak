//
//  ViewController.swift
//  CellMemLeak
//
//  Created by Jay Lyerly on 3/26/21.
//

import Combine
import UIKit

typealias StatusCellRegistration =
    UICollectionView.CellRegistration<UICollectionViewListCell, D1StatusItem>

typealias D1SectionSnapshot = NSDiffableDataSourceSectionSnapshot<D1StatusItem>

class ViewController: UICollectionViewController {
        
    private var cancellables = Set<AnyCancellable>()

    var dataSource: UICollectionViewDiffableDataSource<D1StatusSection, D1StatusItem>?

    let configuration: UICollectionLayoutListConfiguration = {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .firstItemInSection
        config.showsSeparators = false
        return config
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.allowsSelection = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
        
        configureDataSource()
        
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] (_) in
                self?.updateData()
            }
            .store(in: &cancellables)
        
        updateData(animate: false)
    }

    var cellRegistration: StatusCellRegistration {
        let cellRegistration = StatusCellRegistration {
            (cell, _, item) in
            var content = cell.defaultContentConfiguration()
            
            content.text = item.text
            content.textProperties.font = item.font()
            content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
            cell.contentConfiguration = content
            cell.backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
            cell.backgroundConfiguration?.backgroundColor = item.backgroundColor()
            
        }
        return cellRegistration
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<D1StatusSection, D1StatusItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: D1StatusItem) -> UICollectionViewCell? in

            return collectionView
                .dequeueConfiguredReusableCell(using: self.cellRegistration,
                                               for: indexPath,
                                               item: item)
        }
    }
        
    func updateData(animate: Bool = true) {
        dataSource?.apply(infoSnapshot, to: .info)
    }

}


// MARK: Section Snapshots
extension ViewController {
    
    var infoSnapshot: D1SectionSnapshot {
        var snapshot = D1SectionSnapshot()
        let root = D1StatusItem.header(.info)
        
        snapshot.append([root])
        
        //hardware info
        snapshot.append([
            .keyValue("CPU Cores", "3.5"),
            .keyValue("System Memory", "100"),
            .keyValue("Storage", "200")
        ], to: root)
        
        //software info
        snapshot.append([.keyValue("Python Version", "123"),
                         .keyValue("Conda Version", "456"),
                         .keyValue("OS", "macOS")
        ], to: root)
        
        snapshot.expand([root])
        return snapshot
    }
}
