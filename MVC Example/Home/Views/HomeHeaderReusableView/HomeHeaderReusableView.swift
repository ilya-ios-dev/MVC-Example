import UIKit

class HomeHeaderReusableView: UICollectionReusableView {
    @IBOutlet private var label: UILabel!
    
    func render(_ text: String) {
        label.text = text
    }
}
