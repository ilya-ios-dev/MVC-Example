import UIKit

extension UICollectionView.CellRegistration {
    static func createFromNib(
        handler: @escaping UICollectionView.CellRegistration<Cell, Item>.Handler
    ) -> Self {
        let nibName = String(describing: Cell.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        return .init(cellNib: nib, handler: handler)
    }
}
