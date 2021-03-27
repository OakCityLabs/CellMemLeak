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
    
    let statsSection: D1StatusSection
    var sectionIsExpanded = [D1StatusSection: Bool]()
    
    private var cancellables = Set<AnyCancellable>()

    required init?(coder: NSCoder) {
        self.statsSection = D1StatusSection("Stats")
        super.init(coder: coder)
    }
    
    var dataSource: UICollectionViewDiffableDataSource<D1StatusSection, D1StatusItem>?

    let configuration: UICollectionLayoutListConfiguration = {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .firstItemInSection
        config.showsSeparators = false
        return config
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide navBar on Mac
        navigationController?.navigationBar.isHidden = ( UIDevice.current.userInterfaceIdiom == .mac )

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
        let cellRegistration = StatusCellRegistration { [weak self]
            (cell, _, item) in
             var content = cell.defaultContentConfiguration()
            
            content.text = item.text
            content.textProperties.font = item.font()
            content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
            cell.contentConfiguration = content
            cell.backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
            cell.backgroundConfiguration?.backgroundColor = item.backgroundColor()
            
            if case let D1StatusItem.header(section) = item {
                let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
                let outlineAccessory = UICellAccessory
                    .outlineDisclosure(options: headerDisclosureOption) {
                        self?.disclose(section: section)
                    }
                
                cell.accessories = [outlineAccessory]
            }
            
        }
        return cellRegistration
    }
    
    func disclose(section: D1StatusSection) {
        sectionIsExpanded[section]?.toggle()
        updateData(forSection: section, animate: true)
    }
    
    func buttonCellRegistration(name: String, action: UIAction) -> StatusCellRegistration {
        let cellRegistration = StatusCellRegistration {
            (cell, _, item) in

            let content =
                ButtonStatusListConfiguration(label: name,
                                              buttonFont: item.buttonFont(),
                                              labelFont: item.font(),
                                              action: action)
            cell.contentConfiguration = content
            cell.backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
            cell.backgroundConfiguration?.backgroundColor = item.backgroundColor()
        }
        return cellRegistration
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<D1StatusSection, D1StatusItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: D1StatusItem) -> UICollectionViewCell? in
            
            let reg: StatusCellRegistration
            switch item {
            case .buttonValue(let name, let action):
                reg = self.buttonCellRegistration(name: name, action: action)
            default:
                reg = self.cellRegistration
            }
        
            return collectionView
                .dequeueConfiguredReusableCell(using: reg,
                                               for: indexPath,
                                               item: item)
        }
    }
    
    var sectionList: [D1StatusSection] {
        return [
            statsSection,
            .info,
            .environment,
            .packages,
            .cloudStorage
        ]
    }
    
    // This is a list of tuples to maintain ordering.
    // (Dictionary 'keys' don't stay in order)
    func snapshot(forSection section: D1StatusSection) -> D1SectionSnapshot? {
        switch section {
        case statsSection:
            return activitySnapshot
        case .info:
            return infoSnapshot
        case .environment:
            return environmentSnapshot
        case .packages:
            return packageSnapshot
        case .cloudStorage:
            return cloudProviderSnapshot
        default:
            return nil
        }
    }

    func updateData(forSection section: D1StatusSection, animate: Bool = true) {
        guard let snapshot = snapshot(forSection: section) else {
            return
        }
        assert(Thread.isMainThread)
        dataSource?.apply(snapshot, to: section)
    }
    
    func updateData(animate: Bool = true) {
        print("updating...")
        sectionList.forEach { (section) in
            updateData(forSection: section, animate: animate)
        }
    }
    
    func shouldExpand(section: D1StatusSection) -> Bool {
        // Populate the `sectionIsExpanded` dict if needed
        if !sectionIsExpanded.keys.contains(section) {
            sectionIsExpanded[section] = section.autoExpand
        }
        
        return sectionIsExpanded[section] ?? false
    }
}


// MARK: Section Snapshots
extension ViewController {
        
    var serverLogAction: UIAction {
        return UIAction(title: "Open") { (_) in
            print("serverLogAction")
        }
    }

    var environmentSnapshot: D1SectionSnapshot {
        var snapshot = D1SectionSnapshot()
        let root = D1StatusItem.header(.environment)

        snapshot.append([root])

        let env: [String: String] = [
            "foo": "bar",
            "abc": "xyz",
            "score": "123",
        ]
        
        let keys = env.keys
            .sorted { $0.lowercased() < $1.lowercased() }
        let items = keys.map { D1StatusItem.keyValue($0, env[$0] ?? "") }
        snapshot.append(items, to: root)
        
        if shouldExpand(section: .environment) {
            snapshot.expand([root])
        } else {
            snapshot.collapse([root])
        }
        
        return snapshot
    }
    
    var packageSnapshot: D1SectionSnapshot {
        var snapshot = D1SectionSnapshot()
        let root = D1StatusItem.header(.packages)
        
        snapshot.append([root])
        
        let packages: [String: String] = [
            "package1": "super",
            "package2": "duper",
            "package3": "booper"
        ]
                
        let keys = packages.keys
            .sorted { $0.lowercased() < $1.lowercased() }
        let items = keys.map { D1StatusItem.keyValue($0, packages[$0] ?? "") }
        snapshot.append(items, to: root)
        
        if shouldExpand(section: .packages) {
            snapshot.expand([root])
        } else {
            snapshot.collapse([root])
        }
        
        return snapshot
    }
    
    var cloudProviderSnapshot: D1SectionSnapshot {
        var snapshot = D1SectionSnapshot()
        let root = D1StatusItem.header(.cloudStorage)
        snapshot.append([root])
    
        let openCloudVC = UIAction(title: "Cloud Storage") {  _ in
            print("openCloudAction")
        }
        snapshot.append([.buttonValue("Manage", openCloudVC)], to: root)
        if shouldExpand(section: .cloudStorage) {
            snapshot.expand([root])
        }
        return snapshot
        
    }
    
    var activitySnapshot: D1SectionSnapshot {
        var snapshot = D1SectionSnapshot()
        let root = D1StatusItem.header(statsSection)
        
        let connectString = "server is connected."
        
        snapshot.append([root])
        
        let stat = ServerActivity(timestamp: "Now lol",
                                         disk: .init(free: 50, percent: 50, total: 100),
                                         memory: .init(available: 8, total: 16),
                                         cpu: .init(percent: 10,
                                                    loadPercent: 0.1),
                                         gpu: [])
        
        snapshot.append([
            .singleLine(connectString),
            .keyValue("CPU", "\(stat.cpu.percent)%"),
            .keyValue("Memory", "\(stat.memPercentUsed)% used"),
            .keyValue("Storage", "\(Int(stat.disk.percent))% used")
        ], to: root)
        
        if shouldExpand(section: statsSection) {
            snapshot.expand([root])
        } else {
            snapshot.collapse([root])
        }
        
        return snapshot
    }
    
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
        //log
        snapshot.append([.buttonValue("View Log", serverLogAction)], to: root)
        
        
        if shouldExpand(section: .info) {
            snapshot.expand([root])
        } else {
            snapshot.collapse([root])
        }
        return snapshot
    }
}
