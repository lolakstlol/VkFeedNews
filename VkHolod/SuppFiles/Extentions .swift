import UIKit

// MARK: UIViewController

extension UIViewController {

    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? T else {
        fatalError("No initial VC \(name) SB")
        }
        return viewController
    }
}

// MARK: String

extension String {
    func height(labelWidth: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: labelWidth, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font: font],
                                     context:  nil)
        return ceil(size.height)
    }
}

