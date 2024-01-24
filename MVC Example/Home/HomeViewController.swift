import UIKit

class HomeViewController: UIViewController {
    private let rootView = HomeView()
    
    // MARK: - Services
    private let authProvider: AuthProvider = AuthService()
    private let imagesOfTheDayProvider: ImagesOfTheDayProvider = ImagesOfTheDaySerivce()
    private let imagesProvider: UnsplashImagesProvider = UnsplashImagesService()
    private let buildingImagesProvider: BuildingImagesProvider = BuildingImagesService()
    
    // MARK: - Responses
    private var imagesOfTheDay: [ImagesOfTheDayResponse]?
    private var unsplashImages: [UnsplashImageResponse]?
    private var buildingImages: [BuildingResponse]?

    override func loadView() {
        self.view = rootView
        rootView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImages()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        updateViewState()
    }
}

private extension HomeViewController {
    func fetchImages() {
        Task {
            rootView.showLoadingIndicator()
            
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.fetchImagesOfTheDay() }
                group.addTask { await self.fetchUnsplashImages() }
                group.addTask { await self.fetchBuildingImages() }
            }
            
            rootView.hideLoadingIndicator()
            updateViewState()
            navigationItem.rightBarButtonItem = editButtonItem
        }
    }
    
    private func fetchImagesOfTheDay() async {
        guard let userID = try? await authProvider.verifyAuthentication() else {
            return
        }
        self.imagesOfTheDay = try? await imagesOfTheDayProvider.images(for: userID)
    }
    
    private func fetchUnsplashImages() async {
        self.unsplashImages = try? await imagesProvider.images()
    }
    
    private func fetchBuildingImages() async {
        self.buildingImages = try? await buildingImagesProvider.images()
    }
}

private extension HomeViewController {
    func updateViewState() {
        let viewState = HomeViewState(
            sections: [
                imagesOfTheDaySection(),
                unsplashImagesSection(),
                buildingImagesSection()
            ]
                .compactMap { $0 }
        )
        rootView.render(viewState: viewState)
    }
    
    func imagesOfTheDaySection() -> HomeViewState.Section? {
        guard let imagesOfTheDay else {
            return .imagesOfTheDay(reloadSectionState(for: .imageOfTheDay))
        }
        
        if imagesOfTheDay.isEmpty {
            return nil
        }
        
        let imageItems = imagesOfTheDay.compactMap { response -> ImageItemViewState? in
            guard let url = URL(string: response.url) else {
                return nil
            }
            
            return .init(showDeleteButton: !isEditing, url: url, id: ImageItemIdentifier.imageOfTheDay(response.id))
        }
        
        let imagesSection = ImagesSectionState(title: "Images of the day", imageItems: imageItems)
        
        return .imagesOfTheDay(.loaded(imagesSection))
    }
    
    func unsplashImagesSection() -> HomeViewState.Section? {
        guard let unsplashImages else {
            return .unsplashImages(reloadSectionState(for: .unsplashImage))
        }
        
        if unsplashImages.isEmpty {
            return nil
        }

        let imageItems = unsplashImages.compactMap { response -> ImageItemViewState? in
            guard let url = URL(string: response.url) else {
                return nil
            }
            
            return .init(showDeleteButton: !isEditing, url: url, id: ImageItemIdentifier.unsplashImage(response.id))
        }
        
        let imagesSection = ImagesSectionState(title: "Unsplash images", imageItems: imageItems)

        return .unsplashImages(.loaded(imagesSection))
    }
    
    func buildingImagesSection() -> HomeViewState.Section? {
        guard let buildingImages else {
            return .buildingImages(reloadSectionState(for: .buildingImage))
        }
        
        if buildingImages.isEmpty {
            return nil
        }

        let imageItems = buildingImages.compactMap { response -> ImageItemViewState? in
            guard let url = URL(string: response.url) else {
                return nil
            }
            
            return .init(showDeleteButton: !isEditing, url: url, id: ImageItemIdentifier.buildingImage(response.id))
        }
        
        let imagesSection = ImagesSectionState(title: "Building images", imageItems: imageItems)

        return .buildingImages(.loaded(imagesSection))
    }
    
    func reloadSectionState(for section: HomeSectionIdentifier) -> HomeViewState.Section.LoadingState {
        return .needsReload(
            .init(title: "Something went wrong", buttonTitle: "Try again", id: section)
        )
    }
}

// MARK: - HomeViewDelegate
extension HomeViewController: HomeViewDelegate {
    func didTapDeleteButton(_ identifier: IdentifiableSource) {
        guard let identifier = identifier as? ImageItemIdentifier else {
            return
        }
        
        Task {
            switch identifier {
            case .imageOfTheDay(let id):
                imagesOfTheDay = try await imagesOfTheDayProvider.deleteImage(id)
            case .unsplashImage(let id):
                unsplashImages = try await imagesProvider.deleteImage(id)
            case .buildingImage(let id):
                buildingImages = await buildingImagesProvider.deleteImage(id)
            }
            
            updateViewState()
        }
    }
    
    func didTapReloadButton(_ identifier: IdentifiableSource) {
        guard let identifier = identifier as? HomeSectionIdentifier else {
            return
        }
        
        Task {
            rootView.showLoadingIndicator()

            switch identifier {
            case .imageOfTheDay:
                await fetchImagesOfTheDay()
            case .unsplashImage:
                await fetchUnsplashImages()
            case .buildingImage:
                await fetchBuildingImages()
            }
            
            updateViewState()
            
            rootView.hideLoadingIndicator()
        }
    }
}
