import UIKit

import Kingfisher

protocol ImageViewCellDelegate: AnyObject {
    func didSelectDeleteButton(_ identifier: IdentifiableSource)
}

class ImageViewCell: UICollectionViewCell {
    @IBOutlet private var deleteButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    
    private var viewState: ImageItemViewState?
    
    weak var delegate: ImageViewCellDelegate?
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func render(viewState: ImageItemViewState) {
        self.viewState = viewState
        deleteButton.isHidden = viewState.showDeleteButton
        imageView.kf.setImage(
            with: viewState.url,
            options: [.transition(.fade(0.5))]
        )
    }
    
    
    @IBAction private func didSelectDeleteButton() {
        guard let viewState else {
            return
        }
        delegate?.didSelectDeleteButton(viewState.id)
    }
}
