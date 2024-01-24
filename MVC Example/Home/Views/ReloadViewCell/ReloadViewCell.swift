import UIKit

protocol ReloadViewCellDelegate: AnyObject {
    func didTapReloadButton(_ id: IdentifiableSource)
}

class ReloadViewCell: UICollectionViewCell {
    @IBOutlet private var button: UIButton!
    @IBOutlet private var label: UILabel!
    
    weak var delegate: ReloadViewCellDelegate?
    private var viewState: ReloadItemViewState?
    
    func render(viewState: ReloadItemViewState) {
        self.viewState = viewState
        button.setTitle(viewState.buttonTitle, for: .normal)
        label.text = viewState.title
    }
    
    @IBAction private func reloadButtonTapped() {
        guard let viewState else {
            return
        }
        delegate?.didTapReloadButton(viewState.id)
    }
}
