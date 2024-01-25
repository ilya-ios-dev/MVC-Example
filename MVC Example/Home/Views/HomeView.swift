import UIKit

protocol HomeViewDelegate: AnyObject {
    func didTapDeleteButton(_ identifier: IdentifiableSource)
    func didTapReloadButton(_ identifier: IdentifiableSource)
}

class HomeView: UIView {
    private typealias Section = HomeViewState.Section
    private typealias Item = HomeViewState.Item
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private let layoutFactory: HomeViewLayoutFactory = HomeViewLayoutFactoryImpl()

    private let loadingIndicator = SquareLoadingIndicator()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private lazy var dataSource = createDataSource()
    
    private var viewState: HomeViewState?
    weak var delegate: HomeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func render(viewState: HomeViewState) {
        self.viewState = viewState
        var snapshot = Snapshot()
        snapshot.appendSections(viewState.sections)
        viewState.sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot)
        
        if viewState.showLoadingIndicator {
            loadingIndicator.showLoadingIndicator()
        }
        else {
            loadingIndicator.hideLoadingIndicator()
        }
    }
    
    private func setupUI() {
        collectionView.backgroundColor = .systemBackground
        addConstrainedSubview(collectionView)
        addConstrainedSubview(loadingIndicator)
    }
}


// MARK: - Layout
private extension HomeView {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return .init { [weak self] index, _ in
            guard let self, let section = self.viewState?.sections[index] else {
                return nil
            }
            return self.layoutFactory.makeSectionLayout(section)
        }
    }
}

// MARK: - Data Source
private extension HomeView {
    private func createDataSource() -> DataSource {
        let imageCellRegistration = UICollectionView.CellRegistration<ImageViewCell, ImageItemViewState>.createFromNib { cell, _, state in
            cell.render(viewState: state)
            cell.delegate = self
        }
        
        let reloadCellRegistration = UICollectionView.CellRegistration<ReloadViewCell, ReloadItemViewState>.createFromNib { cell, _, state in
            cell.render(viewState: state)
            cell.delegate = self
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<HomeHeaderReusableView>.createHeader { [weak self] header, _, indexPath in
            guard let self, let section = self.viewState?.sections[indexPath.section] else {
                return
            }
            
            switch section.loadingState {
            case .loaded(let state):
                header.render(state.title)
            case .needsReload:
                break
            }
        }

        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
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
        
        return dataSource
    }
}

extension HomeView: ImageViewCellDelegate {
    func didSelectDeleteButton(_ identifier: IdentifiableSource) {
        delegate?.didTapDeleteButton(identifier)
    }
}

extension HomeView: ReloadViewCellDelegate {
    func didTapReloadButton(_ id: IdentifiableSource) {
        delegate?.didTapReloadButton(id)
    }
}
