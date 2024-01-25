import Foundation

protocol HomeViewStateFactory {
    func make(from responses: ImageResponses?, isLoading: Bool, isEditing: Bool) -> HomeViewState
}

class HomeViewStateFactoryImpl: HomeViewStateFactory {
    private typealias Section = HomeViewState.Section
    
    func make(
        from responses: ImageResponses?, 
        isLoading: Bool,
        isEditing: Bool
    ) -> HomeViewState {
        return HomeViewState(
            sections: sections(from: responses, isEditing: isEditing),
            showLoadingIndicator: isLoading
        )
    }
    
    private func sections(from responses: ImageResponses?, isEditing: Bool) -> [Section] {
        // If the entire 'responses' structure is nil, not just its fields, then we don't need to display sections
        guard let responses else {
            return []
        }
        
        return [
            imagesOfTheDaySection(imagesOfTheDay: responses.imagesOfTheDay, isEditing: isEditing),
            unsplashImagesSection(unsplashImages: responses.unsplashImages, isEditing: isEditing),
            buildingImagesSection(buildingImages: responses.buildingImages, isEditing: isEditing)
        ].compactMap { $0 }
    }
    
    private func imagesOfTheDaySection(imagesOfTheDay: [ImagesOfTheDayResponse]?, isEditing: Bool) -> Section? {
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
    
    private func unsplashImagesSection(unsplashImages: [UnsplashImageResponse]?, isEditing: Bool) -> Section? {
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
    
    private func buildingImagesSection(buildingImages: [BuildingResponse]?, isEditing: Bool) -> Section? {
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
    
    private func reloadSectionState(for section: HomeSectionIdentifier) -> Section.LoadingState {
        return .needsReload(
            .init(title: "Something went wrong", buttonTitle: "Try again", id: section)
        )
    }
}
