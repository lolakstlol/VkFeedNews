import UIKit

class FeedViewController: UIViewController {
    
    private struct FeedViewControllerConstants {
        static let dateFormat = "MM-dd-yyyy HH:mm"
        static let cellNibName = "FeedCell"
        static let screenWidth = UIScreen.main.bounds.width
    }
    
    @IBOutlet weak var feedTableView: UITableView!
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkingService())
    var feedViewData: [FeedViewModel.Cell] = []
    var cellLayoutcalc: FeedCellLayoutCalcProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetcher.getFeed { (response) in
            guard let response = response else { return }
            self.updateTableView(model: response)
        }
        setup()
    }
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group]) -> FeedViewModel.Cell {
        let currentProfile = profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        let sizes = cellLayoutcalc.sizes(postText: feedItem.text, photo: fetchPhoto(feedItem: feedItem))
        //это бы в отдельную функцию, так шо не забудь
        let date = Date(timeIntervalSince1970: TimeInterval(feedItem.date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FeedViewControllerConstants.dateFormat
        
        return FeedViewModel.Cell.init(iconImageUrl: currentProfile.photo,
                                       name: currentProfile.name,
                                       date: dateFormatter.string(from: date),
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.likes?.count ?? 0 ),
                                       shares: String(feedItem.likes?.count ?? 0),
                                       views: String(feedItem.likes?.count ?? 0),
                                       contentPhoto: fetchPhoto(feedItem: feedItem),
                                       sizes: sizes)
    }
    
    private func fetchPhoto(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ (attachment) in
            attachment.photo
        }), let firstPhoto = photos.first else {
            return nil
        }
        return FeedViewModel.FeedCellPhotoAttachment.init(photoURL: firstPhoto.url,
                                                          width: firstPhoto.width,
                                                          height: firstPhoto.height)
    }
    
    private func profile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentable {
        if sourseId > 0 {
            return profiles.filter {$0.id == sourseId}.first!
        } else {
            return groups.filter {$0.id == abs(sourseId)}.first!
        }
    }
    
    private func updateTableView(model: FeedResponse) {
        feedViewData = model.items.map { (feedItem) in
            cellViewModel(from: feedItem, profiles: model.profiles, groups: model.groups)
        }
        feedTableView.reloadData()
    }
    
    private func setup() {
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.register(UINib(nibName: FeedViewControllerConstants.cellNibName, bundle: nil), forCellReuseIdentifier: FeedCell.reuseId)
        feedTableView.separatorStyle = .none
        feedTableView.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        cellLayoutcalc = FeedCellLayoutCalc(screenWidth: FeedViewControllerConstants.screenWidth)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseId, for: indexPath) as! FeedCell
        let currentCell = feedViewData[indexPath.row]
        cell.set(model: currentCell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentCell = feedViewData[indexPath.row]
        return currentCell.sizes.totalHeight 
    }
}

