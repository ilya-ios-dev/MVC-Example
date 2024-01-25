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

    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let loadingIndicatorContainer = UIView()
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
            showLoadingIndicator()
        }
        else {
            hideLoadingIndicator()
        }
    }
    
    private func showLoadingIndicator() {
        loadingIndicatorContainer.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loadingIndicatorContainer.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    private func setupUI() {
        collectionView.backgroundColor = .systemBackground
        addConstrainedSubview(collectionView)
        
        loadingIndicatorContainer.isHidden = true
        addConstrainedSubview(loadingIndicatorContainer)
        loadingIndicatorContainer.backgroundColor = .darkGray.withAlphaComponent(0.4)
        
        loadingIndicator.backgroundColor = .white
        loadingIndicator.layer.cornerRadius = 8
        loadingIndicatorContainer.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingIndicatorContainer.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingIndicatorContainer.centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 100),
            loadingIndicator.widthAnchor.constraint(equalTo: loadingIndicator.heightAnchor)
        ])
    }
}


// MARK: - Layout
private extension HomeView {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return .init { [weak self] index, _ in
            guard let self, let section = self.viewState?.sections[index] else {
                return nil
            }
            
            switch section.loadingState {
            case .loaded:
                return self.loadedSection(section)
            case .needsReload(let state):
                return self.reloadSection(state)
            }
        }
    }
    
    private func loadedSection(_ section: Section) -> NSCollectionLayoutSection {
        switch section {
        case .imagesOfTheDay:
            return imagesOfTheDaySection()
        case .unsplashImages:
            return unsplashImagesSection()
        case .buildingImages:
            return buildingImagesSection()
        }
    }
    
    func imagesOfTheDaySection() -> NSCollectionLayoutSection {
        let fractionalWidth: CGFloat = 1 / 3
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(fractionalWidth), heightDimension: .fractionalWidth(fractionalWidth)),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        section.orthogonalScrollingBehavior = .continuous
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func unsplashImagesSection() -> NSCollectionLayoutSection {
        let fractionalWidth: CGFloat = 1 / 3
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(fractionalWidth), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fractionalWidth)),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func buildingImagesSection() -> NSCollectionLayoutSection {
        let fractionalWidth: CGFloat = 1 / 2
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(fractionalWidth), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func reloadSection(_ state: ReloadItemViewState) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
        
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
