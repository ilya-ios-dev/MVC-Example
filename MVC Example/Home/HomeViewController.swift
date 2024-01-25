import UIKit

class HomeViewController: UIViewController {
    
    private let rootView = HomeView()
    
    private let viewStateFactory: HomeViewStateFactory = HomeViewStateFactoryImpl()
    private let imagesProvider: HomeImagesProvider = HomeImagesService()
    
    private var responses: ImageResponses?

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
        updateViewState(showLoading: false)
    }
    
    private func updateViewState(showLoading: Bool) {
        let viewState = viewStateFactory.make(from: responses, isLoading: showLoading, isEditing: isEditing)
        rootView.render(viewState: viewState)
    }
    
    private func fetchImages() {
        Task {
            updateViewState(showLoading: true)
            responses = await imagesProvider.fetchImages()
            updateViewState(showLoading: false)
            navigationItem.rightBarButtonItem = editButtonItem
        }
    }
}

// MARK: - HomeViewDelegate
extension HomeViewController: HomeViewDelegate {
    func didTapDeleteButton(_ identifier: IdentifiableSource) {
        guard let identifier = identifier as? ImageItemIdentifier, let responses else {
            return
        }
        
        Task {
            self.responses = await imagesProvider.deleteImage(with: identifier, currentResult: responses)
            updateViewState(showLoading: false)
        }
    }
    
    func didTapReloadButton(_ identifier: IdentifiableSource) {
        guard let identifier = identifier as? HomeSectionIdentifier, let responses else {
            return
        }
        
        Task {
            updateViewState(showLoading: true)
            self.responses = await imagesProvider.reloadImages(for: identifier, currentResult: responses)
            updateViewState(showLoading: false)
        }
    }
}
