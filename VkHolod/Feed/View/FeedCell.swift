import UIKit


class FeedCell: UITableViewCell {
    
    private struct FeedCellConstants {
        static let id = "FeedCellId"
        static let contentImageCornerRadius: CGFloat = 5.0
        static let postCornerRadius: CGFloat = 10.0
    }
    
    static let reuseId = FeedCellConstants.id
    @IBOutlet weak var mainImage: WebImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var contentImage: WebImageView!
    
    override func prepareForReuse() {
        mainImage.set(imageURL: nil)
        contentImage.set(imageURL: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func set(model: FeedCellModel) {
        mainImage.set(imageURL: model.iconImageUrl)
        nameLabel.text = model.name
        dateLabel.text = model.date
        commentsLabel.text = model.comments
        likesLabel.text = model.likes
        shareLabel.text = model.shares
        viewsLabel.text = model.views
        contentLabel.text = model.text
        contentLabel.frame = model.sizes.postLabelFrame
        contentImage.frame = model.sizes.photoFrame
        bottomView.frame = model.sizes.bottomView
        guard let photo = model.contentPhoto else { return }
        contentImage.set(imageURL: photo.photoURL)
    }
    
    override func setNeedsLayout() {
        mainImage.layer.cornerRadius = mainImage.frame.size.width / 2
        contentImage.layer.cornerRadius = FeedCellConstants.contentImageCornerRadius
        cardView.layer.cornerRadius = FeedCellConstants.postCornerRadius
        mainImage.clipsToBounds = true
        contentImage.clipsToBounds = true
        cardView.clipsToBounds = true
    }
    
}
