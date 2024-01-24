import Foundation

struct HomeViewState: Hashable {
    let sections: [Section]
    
    enum Section: Hashable {
        case imagesOfTheDay(LoadingState)
        case unsplashImages(LoadingState)
        case buildingImages(LoadingState)
        
        enum LoadingState: Hashable {
            case loaded(ImagesSectionState)
            case needsReload(ReloadItemViewState)
        }
        
        var loadingState: LoadingState {
            switch self {
            case .imagesOfTheDay(let state), .unsplashImages(let state), .buildingImages(let state):
                return state
            }
        }
        
        var items: [Item] {
            switch loadingState {
            case .loaded(let imagesSectionState):
                return imagesSectionState.imageItems.map(Item.imageItem)
            case .needsReload(let reloadSectionState):
                return [.reloadItem(reloadSectionState)]
            }
        }
    }
    
    enum Item: Hashable {
        case imageItem(ImageItemViewState)
        case reloadItem(ReloadItemViewState)
    }
}

struct ImagesSectionState: Hashable {
    let title: String
    let imageItems: [ImageItemViewState]
}

struct ImageItemViewState: Hashable {
    let showDeleteButton: Bool
    let url: URL
    @IgnorableHashable var id: IdentifiableSource
}

struct ReloadItemViewState: Hashable {
    let title: String
    let buttonTitle: String
    @IgnorableHashable var id: IdentifiableSource
}
