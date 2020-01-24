import UIKit

protocol FeedCellModel {
    var iconImageUrl: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var contentPhoto: FeedCellContentPhotoModel? { get }
    var sizes: FeedCellSizes { get }
}

protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var photoFrame: CGRect { get }
    var bottomView: CGRect { get }
    var totalHeight: CGFloat { get }
}

protocol FeedCellContentPhotoModel {
    var photoURL: String? { get }
    var width: Int { get }
    var height: Int { get }
    
}

struct FeedViewModel  {
    
    struct Cell: FeedCellModel {
        
        var iconImageUrl: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var contentPhoto: FeedCellContentPhotoModel?
        var sizes: FeedCellSizes
        
    }
    
    struct FeedCellPhotoAttachment: FeedCellContentPhotoModel {
        var photoURL: String?
        var width: Int
        var height: Int
    }
    
    let cells: [Cell]
}

