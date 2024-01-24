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

extension UICollectionView.SupplementaryRegistration {
    static func createHeader(
        handler: @escaping UICollectionView.SupplementaryRegistration<Supplementary>.Handler
    ) -> Self {
        let nibName = String(describing: Supplementary.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        return .init(supplementaryNib: nib, elementKind: UICollectionView.elementKindSectionHeader, handler: handler)
    }
}
