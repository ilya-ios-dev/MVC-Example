import UIKit

class HomeViewController: UIViewController {
    private let rootView = HomeView()
    private let imagesProvider: UnsplashImagesProvider = UnsplashImagesService()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImages()
    }
}

private extension HomeViewController {
    func fetchImages() {
        Task {
            do {
                rootView.showLoadingIndicator()
                let images = try await imagesProvider.images()
                let urls = images.compactMap { URL(string: $0.url) }
                rootView.hideLoadingIndicator()
                rootView.render(imageURLs: urls)
            } catch {
                showAlert("Oops", description: "Something went wrong")
            }
        }
    }
    
    func showAlert(_ title: String, description: String?) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
