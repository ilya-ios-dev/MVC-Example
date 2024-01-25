import UIKit

protocol HomeViewLayoutFactory {
    func makeSectionLayout(_ section: HomeViewState.Section) -> NSCollectionLayoutSection
}

class HomeViewLayoutFactoryImpl: HomeViewLayoutFactory {
    func makeSectionLayout(_ section: HomeViewState.Section) -> NSCollectionLayoutSection {
        switch section.loadingState {
        case .loaded:
            return loadedSectionLayout(section)
        case .needsReload(let reloadItemViewState):
            return reloadSection(reloadItemViewState)
        }
    }
    
    private func loadedSectionLayout(_ section: HomeViewState.Section) -> NSCollectionLayoutSection {
        switch section {
        case .imagesOfTheDay:
            return imagesOfTheDaySection()
        case .unsplashImages:
            return unsplashImagesSection()
        case .buildingImages:
            return buildingImagesSection()
        }
    }
    
    private func imagesOfTheDaySection() -> NSCollectionLayoutSection {
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
    
    private func unsplashImagesSection() -> NSCollectionLayoutSection {
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
    
    private func buildingImagesSection() -> NSCollectionLayoutSection {
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
    
    private func reloadSection(_ state: ReloadItemViewState) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
        
    }
}
