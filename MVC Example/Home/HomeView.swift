import UIKit

class HomeView: UIView {
    enum Section: Hashable {
        case main
    }
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private lazy var dataSource = createDataSource()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func render(imageURLs: [URL]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(imageURLs)
        dataSource.apply(snapshot)
    }
    
    func showLoadingIndicator() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
}

private extension HomeView {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, URL>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, URL>

    func createLayout() -> UICollectionViewCompositionalLayout {
        return .init { _, _ in
            let fraction: CGFloat = 1 / 3
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction)),
                subitems: [item]
            )
            
            return .init(group: group)
        }
    }
    
    func createDataSource() -> DataSource {
        let imageCellRegistration = UICollectionView.CellRegistration<ImageViewCell, URL>.createFromNib { cell, _, url in
            cell.render(url: url)
        }
        
        return .init(collectionView: collectionView) { collectionView, indexPath, url in
            return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: url)
        }
    }
    
    func setupUI() {
        collectionView.backgroundColor = .systemBackground
        addConstrainedSubview(collectionView)
        
        loadingIndicator.isHidden = true
        addConstrainedSubview(loadingIndicator)
    }
}
