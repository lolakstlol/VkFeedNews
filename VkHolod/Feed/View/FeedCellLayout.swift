
import UIKit

protocol FeedCellLayoutCalcProtocol {
    func sizes(postText: String?, photo: FeedCellContentPhotoModel?) -> FeedCellSizes
}

struct Sizes: FeedCellSizes {
    var bottomView: CGRect
    var totalHeight: CGFloat
    var postLabelFrame: CGRect
    var photoFrame: CGRect
}

final class FeedCellLayoutCalc: FeedCellLayoutCalcProtocol {
    
    private struct CellLayoutCosntants {
        static let cardInserts = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
        static let topViewHeight: CGFloat = 45.0
        static let labelInserts = UIEdgeInsets(top: CellLayoutCosntants.topViewHeight + 10 + 3, left: 8, bottom: 8, right: 8)
        static let labelFont = UIFont.systemFont(ofSize: 15)
        static let bottomViewHeight: CGFloat = 50
    }
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photo: FeedCellContentPhotoModel?) -> FeedCellSizes {
        let cardViewWidth = screenWidth - CellLayoutCosntants.cardInserts.left - CellLayoutCosntants.cardInserts.right
        
        //LabelFrame
        var postLabelFrame = CGRect(origin: CGPoint(x: CellLayoutCosntants.labelInserts.left, y: CellLayoutCosntants.labelInserts.top), size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let labelWidth = screenWidth - CellLayoutCosntants.labelInserts.left - CellLayoutCosntants.labelInserts.right
            let height = text.height(labelWidth : labelWidth, font : CellLayoutCosntants.labelFont)
            postLabelFrame.size = CGSize(width: labelWidth, height: height)
        }
        
        //PhotoFrame
        let topInsert = postLabelFrame.size == CGSize.zero ? CellLayoutCosntants.labelInserts.top: postLabelFrame.maxY + CellLayoutCosntants.labelInserts.bottom
        var photoFrame = CGRect(origin: CGPoint(x: 0, y: topInsert), size: CGSize.zero)
        if let photo = photo {
            let ratio: CGFloat = CGFloat(photo.height) / CGFloat(photo.width)
            photoFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
        }
        
        //BottomViewFrame
        let bottomViewTop = max(postLabelFrame.maxY,photoFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop), size: CGSize(width: cardViewWidth, height: CellLayoutCosntants.bottomViewHeight ))
        
        //TotalHeight
        let total = bottomViewFrame.maxY + CellLayoutCosntants.cardInserts.bottom + 3
        print(total)
        return Sizes(bottomView: bottomViewFrame,
                     totalHeight: total,
                     postLabelFrame: postLabelFrame,
                     photoFrame: photoFrame)
    }
    
}
