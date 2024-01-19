import UIKit

import Kingfisher

class ImageViewCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func render(url: URL) {
        imageView.kf.setImage(
            with: url,
            options: [.transition(.fade(0.5)), .forceTransition]
        )
    }
}
