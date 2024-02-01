import UIKit

protocol HomeViewDataSource {
    typealias Delegate = ImageViewCellDelegate & ReloadViewCellDelegate
    init(collectionView: UICollectionView, delegate: Delegate?)
    func applySnapshot(viewState: HomeViewState)
}

class HomeViewDataSourceImpl: HomeViewDataSource {
    typealias Delegate = ImageViewCellDelegate & ReloadViewCellDelegate
    private typealias Section = HomeViewState.Section
    private typealias Item = HomeViewState.Item
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private weak var collectionView: UICollectionView?
    private var dataSource: DataSource!
    weak var delegate: Delegate?

    required init(collectionView: UICollectionView, delegate: Delegate?) {
        self.collectionView = collectionView
        self.delegate = delegate
        configureDataSource()
    }

    private func configureDataSource() {
        guard let collectionView else {
            return
        }
        
        let imageCellRegistration = UICollectionView.CellRegistration<ImageViewCell, ImageItemViewState>.createFromNib { [weak self] cell, _, state in
            cell.render(viewState: state)
            cell.delegate = self?.delegate
        }

        let reloadCellRegistration = UICollectionView.CellRegistration<ReloadViewCell, ReloadItemViewState>.createFromNib { [weak self] cell, _, state in
            cell.render(viewState: state)
            cell.delegate = self?.delegate
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<HomeHeaderReusableView>.createHeader { [weak self] header, _, indexPath in
            guard let self, let section = self.dataSource.sectionIdentifier(for: indexPath.section) else {
                return
            }

            switch section.loadingState {
            case .loaded(let state):
                header.render(state.title)
            case .needsReload:
                break
            }
        }

        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .imageItem(let state):
                return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: state)
            case .reloadItem(let state):
                return collectionView.dequeueConfiguredReusableCell(using: reloadCellRegistration, for: indexPath, item: state)
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath -> UICollectionReusableView? in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }

    func applySnapshot(viewState: HomeViewState) {
        var snapshot = Snapshot()
        snapshot.appendSections(viewState.sections)
        viewState.sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
