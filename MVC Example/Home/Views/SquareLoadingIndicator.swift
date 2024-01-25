import UIKit

class SquareLoadingIndicator: UIView {
    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        isHidden = true
        backgroundColor = .darkGray.withAlphaComponent(0.4)

        loadingIndicator.backgroundColor = .white
        loadingIndicator.layer.cornerRadius = 8
        addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 100),
            loadingIndicator.widthAnchor.constraint(equalTo: loadingIndicator.heightAnchor)
        ])
    }
    
    func showLoadingIndicator() {
        isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        isHidden = true
        loadingIndicator.stopAnimating()
    }
}
